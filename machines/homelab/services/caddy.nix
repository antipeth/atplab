{ config, ... }:
{
  services.caddy = {
    enable = true;
    virtualHosts."http://sync.0pt.us.kg" = {
      extraConfig = ''
        reverse_proxy http://localhost:8384 {
            header_up Host {upstream_hostport}
        }
      '';
    };
    virtualHosts."http://pic.0pt.us.kg" = {
      extraConfig = ''
        reverse_proxy http://[::1]:${toString config.services.immich.port} {
            header_up Host {upstream_hostport}
        }
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
  ];
}
