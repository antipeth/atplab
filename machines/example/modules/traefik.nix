{config, ...}: {
  # if you don't use environmentFiles,
  # you can use these for test.
  # systemd.services.traefik.environment = {
  #   # Please check this url https://go-acme.github.io/lego/dns/
  #   CLOUDFLARE_DNS_API_TOKEN = "your token";
  #   # or
  #   CLOUDFLARE_DNS_API_TOKEN_FILE = "/path/to/File";
  # };

  sops.secrets.crystal-traefik-environment = {
    mode = "0440";
    owner = config.users.users.traefik.name;
    group = config.users.users.traefik.group;
  };

  services.traefik = {
    enable = true;
    environmentFiles = [(config.sops.secrets.crystal-traefik-environment.path)];
    staticConfigOptions = {
      # log = {
      # level = "INFO";
      # filePath = "${config.services.traefik.dataDir}/traefik.log";
      # format = "json";
      # };
      entryPoints = {
        web = {
          address = ":80";
        };
        websecure = {
          address = ":443";
          http.tls = {
            certResolver = "myresolver";
            domains = {
              main = "example.com";
              sans = ["*.example.com"];
            };
          };
        };
      };

      certificatesResolvers.myresolver.acme = {
        dnsChallenge = {
          provider = "cloudflare";
          delayBeforeCheck = 10;
        };
        email = "admin@example.com";
        storage = "${config.services.traefik.dataDir}/acme.json";
        # caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
      };

      api.dashboard = false;
      # Access the Traefik dashboard on <Traefik IP>:8080 of your server
      api.insecure = false;
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          syncthing = {
            entryPoints = ["websecure"];
            rule = "Host(`sync.example.com`)";
            service = "syncthing";
            tls.certresolver = "myresolver";
          };
          headscale = {
            entryPoints = ["websecure"];
            rule = "Host(`headscale.example.com`)";
            service = "headscale";
            tls.certresolver = "myresolver";
          };
          netdata = {
            entryPoints = ["websecure"];
            rule = "Host(`data.example.com`)";
            service = "netdata";
            tls.certresolver = "myresolver";
            # middlewares = "auth";
          };
          cockpit = {
            entryPoints = ["websecure"];
            rule = "Host(`monitor.example.com`)";
            service = "cockpit";
            tls.certresolver = "myresolver";
          };
          immich = {
            entryPoints = ["web"];
            rule = "Host(`pic.nas.local`)";
            service = "immich";
          };
        };
        # middlewares.auth.basicauth.users = "oj3s41wep9mwty:$2y$10$zvfCtPjNvbwNWYcAy/CFmupw40vRuwNr.3VAnzm2ZC9yoFSZP/Tky";
        services = {
          syncthing = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:8384";
                }
              ];
              passHostHeader = false;
            };
          };
          headscale = {
            loadBalancer = {
              servers = [
                {
                  url = "http://127.0.0.1:8080";
                }
              ];
            };
          };
          netdata = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:19999";
                }
              ];
            };
          };
          cockpit = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:9090";
                }
              ];
            };
          };
          wakapi = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:3000";
                }
              ];
            };
          };
          immich = {
            loadBalancer = {
              servers = [
                {
                  url = "http://[::1]:${toString config.services.immich.port}";
                }
              ];
            };
          };
        };
      };
    };
  };
}
