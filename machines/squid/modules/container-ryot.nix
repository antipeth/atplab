{config, ...}: {
  sops.secrets.squid-ryot-env = {
    mode = "0400";
    format = "binary";
    sopsFile = ../secrets/ryot-env;
  };
  virtualisation.oci-containers.containers."ryot" = {
    pull = "newer";
    image = "ghcr.io/ignisda/ryot:latest";
    dependsOn = [
      "postgres"
    ];
    environmentFiles = [config.sops.secrets.squid-ryot-env.path];
    environment = {
      "TZ" = "Asia/Singapore";
      "USERS_ALLOW_REGISTRATION" = "false";
      "DISABLE_TELEMETRY" = "true";
      "FRONTEND_URL" = "https://ryot.0pt.dpdns.org";
      "RUST_LOG" = "ryot=debug";
    };
    ports = [
      "127.0.0.1:18000:8000/tcp"
    ];
  };
  services.nginx.virtualHosts."ryot.0pt.dpdns.org" = {
    forceSSL = true;
    kTLS = true;
    sslCertificate = "/etc/nginx/self-sign.crt";
    sslCertificateKey = "/etc/nginx/self-sign.key";
    extraConfig = ''
      proxy_hide_header X-Powered-By;
      proxy_hide_header Server;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:18000";
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_buffering off;
      '';
    };
  };
}
