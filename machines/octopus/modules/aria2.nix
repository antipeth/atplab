{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.aria2;
in {
  sops.secrets.octopus-aria2-rpc = {
    mode = "0400";
    owner = "aria2";
    group = "aria2";
    format = "binary";
    sopsFile = ../secrets/aria2-rpc;
  };
  services = {
    aria2 = {
      enable = true;
      rpcSecretFile = config.sops.secrets.octopus-aria2-rpc.path;
      settings = {
        # basic
        continue = true;
        max-concurrent-downloads = 5;
        quiet = true;
        # advanced
        allow-overwrite = true;
        auto-file-renaming = true;
        disk-cache = "64M";
        # http/ftp/sftp
        check-certificate = false;
        disable-ipv6 = true;
        max-connection-per-server = 16;
        min-split-size = "8M";
        split = 32;
        user-agent = "Transmission/2.77";
      };
    };
    gatus.settings.endpoints = [
      {
        name = "aria2";
        group = "${config.networking.hostName}";
        url = "tcp://127.0.0.1:${toString cfg.settings.rpc-listen-port}";
        interval = "1h";
        conditions = [
          "[CONNECTED] == true"
          "[RESPONSE_TIME] < 500"
        ];
        alerts = [{type = "gotify";}];
      }
    ];
    nginx.virtualHosts."ariang.0pt.dpdns.org" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      root = "${pkgs.ariang}/share/ariang";
      locations."/jsonrpc" = {
        proxyPass = "http://127.0.0.1:${toString cfg.settings.rpc-listen-port}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
  environment.systemPackages = [
    pkgs.ariang
  ];
}
