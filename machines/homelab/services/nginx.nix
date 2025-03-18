{ config, pkgs, ... }:
{
  # recommendedProxyConfig = pkgs.writeText "nginx-recommended-proxy-headers.conf" ''
  #   proxy_set_header        Host $host;
  #   proxy_set_header        X-Real-IP $remote_addr;
  #   proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
  #   proxy_set_header        X-Forwarded-Proto $scheme;
  #   proxy_set_header        X-Forwarded-Host $host;
  #   proxy_set_header        X-Forwarded-Server $host;
  # '';
  # $connection_upgrade is used for websocket proxying
  # map $http_upgrade $connection_upgrade {
  #     default upgrade;
  #     '''      close;
  # }
  #   ${optionalString config.proxyWebsockets ''
  #   proxy_http_version 1.1;
  #   proxy_set_header Upgrade $http_upgrade;
  #   proxy_set_header Connection $connection_upgrade;
  # ''}
  users.users.nginx.extraGroups = [
    "acme"
  ];
  sops.secrets = {
    homelab-acme-environment = {
      mode = "0440";
      owner = config.users.users.acme.name;
      group = config.users.users.acme.group;
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = import ../../../sops/eval/homelab/acme-cert-email.nix;
    certs."0pt.icu" = {
      domain = "0pt.icu";
      extraDomainNames = [ "*.0pt.icu" ];
      dnsProvider = import ../../../sops/eval/homelab/acme-dns-provider.nix;
      environmentFile = config.sops.secrets.homelab-acme-environment.path;
      dnsPropagationCheck = false;
      # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    };
  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "0pt.icu" = {
        forceSSL = true;
        # sslCertificate = "/var/nas.local.crt";
        # sslCertificateKey = "/var/nas.local.key";
        useACMEHost = "0pt.icu";
      };
      "alist.0pt.icu" = {
        forceSSL = true;
        useACMEHost = "0pt.icu";
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
      "aria2.0pt.icu" = {
        forceSSL = true;
        useACMEHost = "0pt.icu";
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
      # "code.0pt.icu" = {
      #   forceSSL = true;
      #   useACMEHost = "0pt.icu";
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
      "dashboard.0pt.icu" = {
        forceSSL = true;
        useACMEHost = "0pt.icu";
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
      "git.0pt.icu" = {
        forceSSL = true;
        useACMEHost = "0pt.icu";
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
      "glances.0pt.icu" = {
        forceSSL = true;
        useACMEHost = "0pt.icu";
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
      "gotify.0pt.icu" = {
        forceSSL = true;
        useACMEHost = "0pt.icu";
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
      "home.0pt.icu" = {
        forceSSL = true;
        useACMEHost = "0pt.icu";
        locations."/" = {
          proxyPass = "http://[::1]:8123";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };
      "homebox.0pt.icu" = {
        forceSSL = true;
        useACMEHost = "0pt.icu";
        locations."/" = {
          proxyPass = "http://127.0.0.1:7745";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_redirect off;
            proxy_buffering off;
          '';
        };
      };
      "jellyfin.0pt.icu" = {
        forceSSL = true;
        useACMEHost = "0pt.icu";
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
      "pic.0pt.icu" = {
        forceSSL = true;
        useACMEHost = "0pt.icu";
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
      "sync.0pt.icu" = {
        forceSSL = true;
        useACMEHost = "0pt.icu";
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
      "wakapi.0pt.icu" = {
        forceSSL = true;
        useACMEHost = "0pt.icu";
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
