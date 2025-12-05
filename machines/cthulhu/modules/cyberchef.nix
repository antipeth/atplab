{
  config,
  pkgs,
  ...
}: {
  services.nginx.virtualHosts."cyberchef.0pt.de5.net" = {
    forceSSL = true;
    kTLS = true;
    sslCertificate = "/etc/nginx/self-sign.crt";
    sslCertificateKey = "/etc/nginx/self-sign.key";
    basicAuthFile = config.sops.secrets.cthulhu-nginx-basic-auth.path;
    extraConfig = ''
      proxy_hide_header X-Powered-By;
      proxy_hide_header Server;
    '';
    locations."/" = {
      alias = "${pkgs.cyberchef}/share/cyberchef/";
      index = "index.html";
    };
  };
}
