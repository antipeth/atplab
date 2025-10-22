{
  config,
  pkgs,
  ...
}: {
  # Wireguard Peer
  sops.secrets.octopus-dn42-wg-privatekey = {
    mode = "0400";
    format = "binary";
    sopsFile = ../secrets/dn42-wg-private;
  };
  networking.wg-quick.interfaces = {
    dn42-atp = {
      listenPort = 20003;
      address = [
        "fe80::67b3/64"
        "172.20.192.1/28"
        "fd25:5547:5a89::1/48"
      ];
      postUp = ''
        ${pkgs.iproute2}/bin/ip addr add fe80::67b3/64 dev dn42-atp
        ${pkgs.iproute2}/bin/ip addr add fd25:5547:5a89::1/128 dev dn42-atp
        ${pkgs.iproute2}/bin/ip addr add 172.20.192.1/32 peer 172.20.192.2/32 dev dn42-atp
      '';
      peers = [
        {
          publicKey = "1w7XcnqKbjzLRp12JcLn0BEz4C3AMR4R+a6fbSHR5HM=";
          allowedIPs = [
            "10.0.0.0/8"
            "172.20.0.0/14"
            "172.31.0.0/16"
            "fd00::/8"
            "fe80::/64"
          ];
          endpoint = import ../values/dn42-peer-atp-squid.nix;
          # publicKey: L4c8C+/CPPfD0PuuwDUVz7mtzO8c9eCtf4vkBoxPSWc=
        }
      ];
      privateKeyFile = config.sops.secrets.octopus-dn42-wg-privatekey.path;
    };
  };
  networking.firewall = {
    allowedTCPPorts = [20003];
    allowedUDPPorts = [20003];
  };

  # # Bird config
  # services.bird = {
  #   enable = true;
  #   package = pkgs.bird2;
  #   checkConfig = false;
  #   config = import ../dn42/bird.nix;
  # };
  # # Generate peers config in /etc/bird/peers/* location
  # environment.etc = let
  #   birdPeers = ["atp-squid"];
  #   mkConf = name: {
  #     user = "bird";
  #     group = "bird";
  #     mode = "0400";
  #     text = import ../dn42/peers/${name}.nix;
  #   };
  # in
  #   builtins.listToAttrs (map (n: {
  #       name = "bird/peers/${n}.conf";
  #       value = mkConf n;
  #     })
  #     birdPeers);
  #
  # systemd = {
  #   # Timer for pull ROA table and auto reload bird2
  #   timers.dn42-roa = {
  #     description = "Trigger a monthly ROA table update";
  #     timerConfig = {
  #       OnBootSec = "5m";
  #       OnUnitInactiveSec = "1d";
  #       Unit = "dn42-roa.service";
  #     };
  #     wantedBy = ["timers.target"];
  #     # before = ["bird.service"];
  #   };
  #   services.dn42-roa = let
  #     script = pkgs.writeShellScriptBin "update-roa" ''
  #       mkdir -p /etc/bird/
  #       ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42_v6.conf https://dn42.burble.com/roa/dn42_roa_bird2_6.conf
  #       ${pkgs.curl}/bin/curl -sfSLR {-o,-z}/etc/bird/roa_dn42.conf https://dn42.burble.com/roa/dn42_roa_bird2_4.conf
  #       ${pkgs.bird2}/bin/birdc configure
  #       ${pkgs.bird2}/bin/birdc reload in all
  #     '';
  #   in {
  #     after = ["network.target"];
  #     description = "DN42 ROA Updater";
  #     serviceConfig = {
  #       Type = "oneshot";
  #       ExecStart = "${script}/bin/update-roa";
  #     };
  #   };
  #
  #   # Watcher for peers file modified
  #   paths.bird-peers-watch = {
  #     description = "Watch /etc/bird/peers for changes";
  #     pathConfig = {
  #       PathChanged = "/etc/bird/peers";
  #       PathModified = "/etc/bird/peers";
  #       DirectoryNotEmpty = "/etc/bird/peers";
  #       Unit = "bird-reload.service";
  #     };
  #     wantedBy = ["multi-user.target"];
  #   };
  #   services.bird-reload = {
  #     description = "Reload BIRD when peers config changes";
  #     after = ["network.target" "bird.service"];
  #     serviceConfig = {
  #       Type = "oneshot";
  #       ExecStart = "${pkgs.bird2}/bin/birdc configure";
  #     };
  #   };
  # };
}
