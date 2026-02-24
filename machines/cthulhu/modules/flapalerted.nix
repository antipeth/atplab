{config, ...}: let
  cfg = config.services.flapalerted;
in {
  services = {
    flapalerted = {
      enable = true;
      settings = {
        asn = 4242420003;
        bgpListenAddress = "127.0.0.1:1790";
        httpAPIListenAddress = "127.0.0.1:8080";
        routeChangeCounter = 120;
        overThresholdTarget = 5;
        underThresholdTarget = 30;
      };
      birdConfig = ''
        protocol bgp flapalerted {
          local as 4242420003;

          neighbor 127.0.0.1 as 4242420003 port 1790;

          ipv4 {
            add paths on;
            export all;
            import none;
          };

          ipv6 {
            add paths on;
            export all;
            import none;
          };
        }
      '';
    };
    nginx.virtualHosts."flapalerted.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://${cfg.settings.httpAPIListenAddress}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}
