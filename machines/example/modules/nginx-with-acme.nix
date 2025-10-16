{
  config,
  pkgs,
  ...
}: {
  users.users.nginx.extraGroups = [
    "acme"
  ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@example.com";
    certs."example.com" = {
      domain = "example.com";
      extraDomainNames = ["*.example.com"];
      dnsProvider = "cloudflare";
      environmentFile = /run/secret;
      dnsPropagationCheck = false;
      # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    };
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
      };
      "alist.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:5244";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Range $http_range;
            proxy_set_header If-Range $http_if_range;
            proxy_redirect off;

            # Nginx by default only allows file uploads up to 1M in size
            client_max_body_size 50000M;

            # Timeout settings
            proxy_connect_timeout 600s;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;

            # Set as shown below. You can use other values for the numbers as you wish
            proxy_headers_hash_max_size 512;
            proxy_headers_hash_bucket_size 128;
          '';
        };
      };
      "aria2.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        root = "${pkgs.ariang}/share/ariang";
        locations."/jsonrpc" = {
          proxyPass = "http://127.0.0.1:${toString config.services.aria2.settings.rpc-listen-port}";
          extraConfig = ''
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
      # "code.example.com" = {
      #   forceSSL = true;
      #   useACMEHost = "example.com";
      #   locations."/" = {
      #     proxyPass = "http://127.0.0.1:8080";
      #     extraConfig = ''
      #       proxy_set_header Host $host;
      #       proxy_set_header Upgrade $http_upgrade;
      #       proxy_set_header Connection upgrade;
      #       proxy_set_header Accept-Encoding gzip;
      #     '';
      #   };
      # };
      "dashboard.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:9090";
          extraConfig = ''
            # proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $host;
            proxy_redirect off;

            # Required for web sockets to function
            proxy_http_version 1.1;
            proxy_buffering off;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            # Pass ETag header from Cockpit to clients.
            # See: https://github.com/cockpit-project/cockpit/issues/5239
            gzip off;

            # Nginx by default only allows file uploads up to 1M in size
            # client_max_body_size 50000M;

            # Timeout settings
            proxy_connect_timeout 600s;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;

            # Set as shown below. You can use other values for the numbers as you wish
            proxy_headers_hash_max_size 512;
            proxy_headers_hash_bucket_size 128;
          '';
        };
      };
      "git.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          extraConfig = ''
            proxy_set_header Connection $http_connection;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $host;

            # Nginx by default only allows file uploads up to 1M in size
            client_max_body_size 512M;
          '';
        };
      };
      "glances.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:61208";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $host;
            proxy_redirect off;

            # Nginx by default only allows file uploads up to 1M in size
            # client_max_body_size 50000M;

            # Timeout settings
            proxy_connect_timeout 600s;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;

            # Set as shown below. You can use other values for the numbers as you wish
            proxy_headers_hash_max_size 512;
            proxy_headers_hash_bucket_size 128;
          '';
        };
      };
      "gotify.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:1245";
          extraConfig = ''
            proxy_http_version 1.1;

            proxy_set_header   Upgrade $http_upgrade;
            proxy_set_header   Connection "upgrade";
            proxy_set_header   X-Real-IP $remote_addr;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;


            proxy_set_header Host $host;
            proxy_redirect off;

            # Nginx by default only allows file uploads up to 1M in size
            # client_max_body_size 50000M;

            # Timeout settings
            proxy_connect_timeout 1m;
            proxy_read_timeout    1m;
            proxy_send_timeout    1m;

            # Set as shown below. You can use other values for the numbers as you wish
            proxy_headers_hash_max_size 512;
            proxy_headers_hash_bucket_size 128;
          '';
        };
      };
      "home.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations."/" = {
          proxyPass = "http://[::1]:8123";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };
      "homebox.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:7745";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_redirect off;
            proxy_buffering off;
          '';
        };
      };
      "jellyfin.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8096";
            recommendedProxySettings = true;
            extraConfig = ''
              proxy_redirect off;
              proxy_buffering off;
              client_max_body_size 500M;
            '';
          };
          "/socket" = {
            proxyPass = "http://127.0.0.1:8096";
            recommendedProxySettings = true;
            proxyWebsockets = true;
          };
        };
      };
      "pic.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations."/" = {
          proxyPass = "http://[::1]:${toString config.services.immich.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $host;
            proxy_redirect off;

            # Nginx by default only allows file uploads up to 1M in size
            client_max_body_size 50000M;

            # Timeout settings
            proxy_connect_timeout 600s;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;

            # Set as shown below. You can use other values for the numbers as you wish
            proxy_headers_hash_max_size 512;
            proxy_headers_hash_bucket_size 128;
          '';
        };
      };
      "radicale.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations."/radicale/" = {
          proxyPass = "http://127.0.0.1:5232/";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_set_header  X-Script-Name /radicale;
            proxy_set_header  X-Forwarded-Port $server_port;
            proxy_pass_header Authorization;
            proxy_redirect off;
          '';
        };
      };
      "romm.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          recommendedProxySettings = true;
          proxyWebsockets = true;
          extraConfig = ''
            # Hide version
            server_tokens off;

            # Security headers
            add_header X-Frame-Options "SAMEORIGIN" always;
            add_header X-Content-Type-Options "nosniff" always;
            add_header X-XSS-Protection "1; mode=block" always;
            add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
            add_header Referrer-Policy "no-referrer-when-downgrade" always;
          '';
        };
      };
      "sync.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            # For syncthing ,it would dheck the host header
            # proxy_set_header Host $host;
            proxy_redirect off;

            # Nginx by default only allows file uploads up to 1M in size
            # client_max_body_size 50000M;

            # Timeout settings
            proxy_connect_timeout 600s;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;

            # Set as shown below. You can use other values for the numbers as you wish
            proxy_headers_hash_max_size 512;
            proxy_headers_hash_bucket_size 128;
          '';
        };
      };
      "wakapi.example.com" = {
        forceSSL = true;
        useACMEHost = "example.com";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $host;
          '';
        };
      };
    };
  };
}
