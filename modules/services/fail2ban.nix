{ config, ... }:
{
  services.fail2ban = {
    enable = true;
    # Ban IP after 3 failures
    maxretry = 3;
    bantime = "24h"; # Ban IPs for one day on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
    jails = {
      grafana = {
        enabled = config.services.grafana.enable;
      };
      murmur = {
        enabled = config.services.murmur.enable;
      };
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
        enabled = true;
      };
      traefik-auth = {
        enabled = config.services.traefik.enable;
      };
    };
  };
}
