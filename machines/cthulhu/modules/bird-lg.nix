{
  config,
  hostname,
  ...
}: let
  cfg = config.services.bird-lg;
in {
  services = {
    bird-lg = {
      frontend = {
        enable = true;
        listenAddresses = "127.0.0.1:15000";
        proxyPort = 18000;
        domain = "";
        servers = ["${hostname}<127.0.0.1>"];
        netSpecificMode = "dn42";
        protocolFilter = ["bgp" "rpki"];
        extraArgs = ["--trust-proxy-headers"];
      };
      proxy = {
        enable = true;
        listenAddresses = "127.0.0.1:${toString cfg.frontend.proxyPort}";
      };
    };
    nginx.virtualHosts."lg.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/" = {
        proxyPass = "http://${cfg.frontend.listenAddresses}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}
