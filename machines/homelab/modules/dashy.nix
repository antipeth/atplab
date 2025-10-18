_: {
  services = {
    nginx.virtualHosts."dashy.0pt.lab" = {
      forceSSL = true;
      kTLS = true;
      sslCertificate = "/etc/nginx/self-sign.crt";
      sslCertificateKey = "/etc/nginx/self-sign.key";
      extraConfig = ''
        proxy_hide_header X-Powered-By;
        proxy_hide_header Server;
      '';
    };
    dashy = {
      enable = true;
      virtualHost = {
        domain = "dashy.0pt.lab";
        enableNginx = true;
      };
      settings = {
        appConfig = {
          theme = "cherry-blossom";
          layout = "horizontal";
          iconSize = "large";
        };
        pageInfo = {
          title = "🧊 NAS";
          description = "Homepage for 🧊 Nas";
          navLinks = [
            {
              path = "/";
              title = "Home";
            }
            {
              path = "https://dashy.0pt.lab";
              title = "Blog";
            }
            {
              path = "https://chat.example.com";
              title = "NextChat";
            }
            {
              path = "https://github.com/antipeth";
              title = "Github";
            }
          ];
        };
        sections = [
          {
            name = "Clock";
            icon = "mdi-clock-time-four";
            displayData = {
              collapsed = false;
              cols = 1;
              itemSize = "small";
            };
            widgets = [
              {
                type = "clock";
                options = {
                  timeZone = "Asia/Singapore";
                  format = "en-US";
                  hideDate = false;
                };
              }
            ];
          }
          {
            name = "Search";
            icon = "mdi-search-web";
            displayData = {
              collapsed = false;
              cols = 1;
              itemSize = "small";
            };
            widgets = [
              {
                type = "custom-search";
                options = {
                  placeholder = "Search for something using the buttons below";
                  engines = [
                    {
                      title = "Disroot";
                      url = "https://search.disroot.org/?q=";
                    }
                  ];
                };
              }
            ];
          }
          {
            name = "Getting Started";
            icon = "mdi-rocket-launch";
            displayData = {
              collapsed = false;
              cols = 2;
              itemSize = "large";
            };
            items = [
              {
                title = "Homebox";
                description = "A simple home inventory management software";
                icon = "hl-homebox";
                url = "https://homebox.0pt.lab";
                target = "newtab";
              }
              {
                title = "Forgejo";
                description = "Git Server in local";
                icon = "hl-forgejo";
                url = "https://git.0pt.lab";
                target = "newtab";
              }
              {
                title = "Openlist";
                description = "File Client for the local";
                icon = "hl-alist";
                url = "https://openlist.0pt.lab";
                target = "newtab";
              }
              {
                title = "Ariang";
                description = "A modern web frontend making aria2 easier to use.";
                icon = "hl-ariang";
                url = "https://aria2.0pt.lab";
                target = "newtab";
              }
              {
                title = "Gotify";
                description = "Seft-built notification server";
                icon = "hl-gotify";
                url = "https://gotify.0pt.lab";
                target = "newtab";
              }
              {
                title = "Glances";
                description = "Monitor yourself";
                icon = "hl-glances-light";
                url = "https://glances.0pt.lab";
                target = "newtab";
              }
              {
                title = "Grafana";
                description = "Monitor Dashboard";
                icon = "hl-grafana";
                url = "https://grafana.0pt.lab";
                target = "newtab";
              }
            ];
          }
          {
            name = "System Usage";
            icon = "mdi-nas";
            displayData = {
              collapsed = false;
              cols = 1;
              itemSize = "small";
            };
            widgets = [
              {
                type = "gl-current-cpu";
                options = {
                  hostname = "https://glances.0pt.lab";
                };
              }
              {
                type = "gl-current-mem";
                options = {
                  hostname = "https://glances.0pt.lab";
                };
              }
              {
                type = "gl-alerts";
                options = {
                  hostname = "https://glances.0pt.lab";
                };
              }
            ];
          }
          {
            name = "System Load";
            icon = "mdi-server";
            displayData = {
              collapsed = false;
              itemSize = "small";
            };
            widgets = [
              {
                type = "gl-system-load";
                options = {
                  hostname = "https://glances.0pt.lab";
                };
              }
            ];
          }
          {
            name = "History";
            icon = "mdi-chart-areaspline";
            displayData = {
              collapsed = false;
              cols = 1;
              itemSize = "medium";
            };
            widgets = [
              {
                type = "gl-cpu-history";
                options = {
                  hostname = "https://glances.0pt.lab";
                  limit = 60;
                };
              }
              {
                type = "gl-mem-history";
                options = {
                  hostname = "https://glances.0pt.lab";
                  limit = 80;
                };
              }
              {
                type = "gl-load-history";
                options = {
                  hostname = "https://glances.0pt.lab";
                };
              }
            ];
          }
          {
            name = "Disk Info";
            icon = "mdi-harddisk";
            displayData = {
              collapsed = true;
              cols = 2;
              itemSize = "small";
            };
            widgets = [
              {
                type = "gl-disk-space";
                options = {
                  hostname = "https://glances.0pt.lab";
                };
              }
              {
                type = "gl-disk-io";
                options = {
                  hostname = "https://glances.0pt.lab";
                };
              }
            ];
          }
          {
            name = "IP Check";
            icon = "mdi-ip";
            displayData = {
              collapsed = false;
              cols = 2;
              itemSize = "small";
            };
            widgets = [
              {
                type = "public-ip";
                options = {
                  provider = "ipapi.co";
                };
              }
            ];
          }
        ];
      };
    };
  };
}
