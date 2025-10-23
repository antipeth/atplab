{
  config,
  pkgs,
  lib,
  ...
}:
lib.mkIf true {
  # Wireguard Peer
  sops.secrets.squid-dn42-wg-privatekey = {
    mode = "0400";
    format = "binary";
    sopsFile = ../secrets/dn42-wg-private;
  };
  networking.wg-quick.interfaces = {
    dn42-atp = {
      listenPort = 20003;
      address = [
        "fe80::b72b/64"
        "172.20.192.2/28"
        "fd25:5547:5a89::2/48"
      ];
      postUp = ''
        ${pkgs.iproute2}/bin/ip addr add fe80::b72b/64 dev dn42-atp
        ${pkgs.iproute2}/bin/ip addr add fd25:5547:5a89::2/128 dev dn42-atp
        ${pkgs.iproute2}/bin/ip addr add 172.20.192.2/32 peer 172.20.192.1/32 dev dn42-atp
      '';
      peers = [
        {
          publicKey = "L4c8C+/CPPfD0PuuwDUVz7mtzO8c9eCtf4vkBoxPSWc=";
          allowedIPs = [
            "10.0.0.0/8"
            "172.20.0.0/14"
            "172.31.0.0/16"
            "fd00::/8"
            "fe80::/64"
          ];
          endpoint = import ../values/dn42-peer-atp-octopus.nix;
          # publicKey: 1w7XcnqKbjzLRp12JcLn0BEz4C3AMR4R+a6fbSHR5HM=
        }
      ];
      privateKeyFile = config.sops.secrets.squid-dn42-wg-privatekey.path;
    };
  };
  networking.firewall = {
    allowedTCPPorts = [20003];
    allowedUDPPorts = [20003];
  };

  # Bird config
  services.bird = {
    enable = true;
    package = pkgs.bird2;
    checkConfig = false;
    config = import ../dn42/bird.nix;
  };
  # Generate peers config in /etc/bird/peers/* location
  environment.etc = let
    birdPeers = ["atp_octopus"];
    mkConf = name: {
      user = "bird";
      group = "bird";
      mode = "0400";
      text = import ../dn42/peers/${name}.nix;
    };
  in
    builtins.listToAttrs (map (n: {
        name = "bird/peers/${n}.conf";
        value = mkConf n;
      })
      birdPeers);
  systemd = {
    # Watcher for peers file modified
    paths.bird-peers-watch = {
      description = "Watch /etc/bird/peers for changes";
      pathConfig = {
        PathChanged = "/etc/bird/peers";
        PathModified = "/etc/bird/peers";
        Unit = "bird-reload.service";
      };
      wantedBy = ["multi-user.target"];
    };
    # Timer for pull ROA table and auto reload bird2
    timers.dn42-roa = {
      description = "Trigger a monthly ROA table update";
      timerConfig = {
        OnCalendar = "daily";
        Unit = "dn42-roa.service";
      };
      wantedBy = ["timers.target"];
    };
    services = {
      init-roa = {
        description = "Initialize DN42 ROA tables before BIRD starts";
        before = ["bird.service"];
        wantedBy = ["bird.service"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = let
            script = pkgs.writeShellScriptBin "init-roa" ''
              mkdir -p /etc/bird/
              ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42_v6.conf https://dn42.burble.com/roa/dn42_roa_bird2_6.conf
              ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42.conf https://dn42.burble.com/roa/dn42_roa_bird2_4.conf
            '';
          in "${script}/bin/init-roa";
        };
      };
      bird-reload = {
        description = "Reload BIRD when peers config changes";
        after = ["network.target" "bird.service"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.bird2}/bin/birdc configure";
        };
      };
      dn42-roa = {
        description = "DN42 ROA Updater";
        after = ["network.target" "bird.service"];
        serviceConfig = let
          script = pkgs.writeShellScriptBin "update-roa" ''
            mkdir -p /etc/bird/
            ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42_v6.conf https://dn42.burble.com/roa/dn42_roa_bird2_6.conf
            ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42.conf https://dn42.burble.com/roa/dn42_roa_bird2_4.conf
            ${pkgs.bird2}/bin/birdc configure
            ${pkgs.bird2}/bin/birdc reload in all
          '';
        in {
          Type = "oneshot";
          ExecStart = "${script}/bin/update-roa";
        };
      };
    };
  };
}
