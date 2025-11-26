{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.headscale;
in {
  services = {
    headscale = {
      enable = true;
      address = "127.0.0.1";
      port = 8080;
      settings = {
        dns = {
          nameservers.global = [
            "127.0.0.1"
            "::1"
          ];
          magic_dns = false;
          # base_domain = import ../values/hs-md-bd.nix;
        };
        server_url = "https://hs.0pt.dpdns.org";
      };
    };
    gatus.settings.endpoints = [
      {
        name = "headscale";
        group = "${config.networking.hostName}";
        url = "tcp://${cfg.address}:${toString cfg.port}";
        interval = "1h";
        conditions = [
          "[CONNECTED] == true"
          "[RESPONSE_TIME] < 500"
        ];
        alerts = [{type = "gotify";}];
      }
    ];
    nginx.virtualHosts."hs.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
      locations."/web/" = {
        alias = "${pkgs.headscale-ui}/web/";
        index = "index.html";
      };
      locations."/" = {
        proxyPass = "http://${cfg.address}:${toString cfg.port}";
        recommendedProxySettings = true;
        proxyWebsockets = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
  nixpkgs.overlays = [
    (final: prev: {
      headscale-ui = prev.callPackage ../../../pkgs/headscale-ui/default.nix {};
    })
  ];
  environment.systemPackages = [pkgs.headscale-ui];
}
