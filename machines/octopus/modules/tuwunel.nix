{config, ...}: let
  cfg = config.services.matrix-tuwunel;
in {
  services = {
    matrix-tuwunel = {
      enable = true;
      settings = {
        global = {
          address = ["127.0.0.1"];
          port = [6167];
          server_name = "0pt.dpdns.org";
          allow_federation = false;
          allow_registration = false;
          well_known = {
            client = "https://tuwunel.0pt.dpdns.org";
            server = "tuwunel.0pt.dpdns.org:443";
          };
        };
      };
    };
    nginx.virtualHosts = {
      "0pt.dpdns.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
        extraConfig = ''
          proxy_hide_header X-Powered-By;
          proxy_hide_header Server;
        '';
        locations."/.well-known/matrix/" = {
          proxyPass = "http://127.0.0.1:6167/.well-known/matrix/";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
            client_max_body_size 20000m;
          '';
        };
      };
      "tuwunel.0pt.dpdns.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
        extraConfig = ''
          proxy_hide_header X-Powered-By;
          proxy_hide_header Server;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:6167";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
            client_max_body_size 20000m;
          '';
        };
      };
    };
  };
}
