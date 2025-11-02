{
  config,
  pkgs,
  ...
}: let
  gft = import ../values/gotify-fail2ban-token.nix;
in {
  environment.etc = {
    # Define an action that will trigger a Ntfy push notification upon the issue of every new ban
    "fail2ban/action.d/gotify.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [Definition]
      norestored = true

      actionban = curl "https://gotify.0pt.dpdns.org/message?token=${gft}" -F "title=[Fail2Ban] <ip> banned" -F "message=<name> jail has banned <ip> on $(hostname) after <failures> failed attempts." -F "priority=3"

      actionunban = curl "https://gotify.0pt.dpdns.org/message?token=${gft}" -F "title=[Fail2Ban] <ip> unbanned" -F "message=<name> jail has unbanned <ip> on $(hostname)." -F "priority=2"
    '');
  };
  services = {
    openssh.settings = {
      LogLevel = "VERBOSE";
    };
    fail2ban = {
      enable = true;
      extraPackages = with pkgs; [curl hostname];
      # Ban IP after 5 failures
      maxretry = 5;
      ignoreIP = [
        (import ../values/ipv4-address1.nix)
      ];
      bantime = "24h"; # Ban IPs for one day on the first ban
      bantime-increment = {
        enable = true; # Enable increment of bantime after each violation
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h"; # Do not ban for more than 1 week
        overalljails = true; # Calculate the bantime based on all the violations
      };
      jails = {
        nginx-bad-request = {
          enabled = config.services.nginx.enable;
        };
        nginx-botsearch = {
          enabled = config.services.nginx.enable;
        };
        nginx-http-auth = {
          enabled = config.services.nginx.enable;
        };
        sshd = {
          settings = {
            enabled = true;
            filter = "sshd";
            banaction = "nftables";
            backend = "systemd";
            action = ''nftables-multiport[name=sshd, port="ssh", protocol=tcp] gotify'';
          };
        };
      };
    };
  };
}
