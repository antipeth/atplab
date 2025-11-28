{pkgs, ...}: {
  # Bird config
  services.bird = {
    enable = true;
    package = pkgs.bird2;
    checkConfig = false;
    config = import ./bird-config.nix;
  };
  # Generate peers config in /etc/bird/peers/* location
  environment.etc = let
    birdPeers = ["atp_squid" "atp_cthulhu"];
    mkConf = name: {
      user = "bird";
      group = "bird";
      mode = "0400";
      text = import ./peers/${name}.nix;
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
        OnCalendar = "hourly";
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
