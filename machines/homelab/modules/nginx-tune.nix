{pkgs, ...}: {
  environment.etc = {
    "nginx/self-sign.crt" = {
      mode = "0755";
      text = import ../../../sops/eval/homelab/self-sign-crt.nix;
    };
    "nginx/self-sign.key" = {
      mode = "0755";
      text = import ../../../sops/eval/homelab/self-sign-key.nix;
    };
  };
  services.nginx = {
    enable = true;
    package = pkgs.nginxMainline;
    enableReload = true;
    proxyTimeout = "600s";

    # Improve performance
    recommendedOptimisation = true; # Improve static performance

    # High Concurrency
    appendConfig = ''
      worker_rlimit_nofile 65535;
    '';
    eventsConfig = ''
      use epoll;
      worker_connections 65535;
      multi_accept on;
    '';

    # Compress
    recommendedBrotliSettings = true; # Suitable for edge nodes and local network environments
    recommendedGzipSettings = true; # For compatibility

    # Security
    appendHttpConfig = ''
      ssl_ecdh_curve X25519:secp384r1;
      ssl_session_timeout 10m;
      ssl_session_cache shared:SSL:10m;
      ssl_session_tickets off;
      ssl_prefer_server_ciphers on;

      # Add HSTS header with preloading to HTTPS requests.
      # Adding this header to HTTP requests is discouraged
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;

      # Enable CSP for your services.
      # add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
      # add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self'; frame-ancestors 'none';" always;

      # Minimize information leaked to other domains
      add_header 'Referrer-Policy' 'origin-when-cross-origin';

      # Disable embedding as a frame
      add_header X-Frame-Options DENY;

      # Prevent injection of code in other mime types (XSS Attacks)
      add_header X-Content-Type-Options nosniff;

      # This might create errors
      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";

      add_header X-XSS-Protection "1; mode=block" always;
      add_header Permissions-Policy "geolocation=(), microphone=(), camera=(), payment=(), usb=(), magnetometer=(), gyroscope=(), accelerometer=()" always;

    '';
    sslProtocols = "TLSv1.3";
    serverTokens = false; # Hide version information

    virtualHosts = {
      "_" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
        locations."/" = {
          extraConfig = ''
            return 403;
          '';
        };
      };
      "glances.0pt.icu" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
        extraConfig = ''
          proxy_hide_header X-Powered-By;
          proxy_hide_header Server;

          if ($host !~ ^(glances\.0pt\.icu)$) {
            return 444;
          }
        '';
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:61208";
            recommendedProxySettings = true;
          };
          "~ /\.(git|svn|htaccess|htpasswd|env)" = {
            extraConfig = ''
              deny all;
              return 404;
            '';
          };
        };
      };
    };
  };
}
