{config, ...}: let
  cfg = config.services.kavita;
in {
  sops.secrets.octopus-kavita-token = {
    mode = "0400";
    owner = cfg.user;
    group = cfg.user;
    format = "binary";
    sopsFile = ../secrets/kavita-token;
  };
  services = {
    kavita = {
      enable = true;
      settings = {
        IpAddresses = "127.0.0.1";
        Port = 15000;
      };
      tokenKeyFile = config.sops.secrets.octopus-kavita-token.path;
    };
    nginx.virtualHosts."kavita.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.kavita.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.kavita.settings.TARGET = "http://${cfg.settings.IpAddresses}:${toString cfg.settings.Port}";
  };
}
