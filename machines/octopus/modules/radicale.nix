{config, ...}: {
  sops.secrets.octopus-radicale-passwd = {
    mode = "0400";
    owner = "radicale";
    group = "radicale";
    format = "binary";
    sopsFile = ../secrets/radicale-passwd;
  };
  services = {
    radicale = {
      enable = true;
      settings = {
        server.hosts = ["127.0.0.1:5232"];
        auth = {
          type = "htpasswd";
          htpasswd_filename = config.sops.secrets.octopus-radicale-passwd.path;
          htpasswd_encryption = "bcrypt";
        };
        storage = {
          filesystem_folder = "/var/lib/radicale/collections";
        };
      };
      rights = {
        root = {
          user = ".+";
          collection = "";
          permissions = "R";
        };
        principal = {
          user = ".+";
          collection = "{user}";
          permissions = "RW";
        };
        calendars = {
          user = ".+";
          collection = "{user}/[^/]+";
          permissions = "rw";
        };
      };
    };
    nginx.virtualHosts."radicale.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://unix:${toString config.services.anubis.instances.radicale.settings.BIND}:";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
    anubis.instances.radicale.settings.TARGET = "http://127.0.0.1:5232";
  };
}
