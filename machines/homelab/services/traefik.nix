{config, ...}: {
  services.traefik = {
    enable = true;
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
      };

      api.dashboard = false;
      # Access the Traefik dashboard on <Traefik IP>:8080 of your server
      api.insecure = false;
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          syncthing = {
            entryPoints = ["web"];
            rule = "Host(`sync.nas.local`)";
            service = "syncthing";
          };
          immich = {
            entryPoints = ["web"];
            rule = "Host(`pic.nas.local`)";
            service = "immich";
          };
        };
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
  networking.firewall.allowedTCPPorts = [
    80
  ];
}
