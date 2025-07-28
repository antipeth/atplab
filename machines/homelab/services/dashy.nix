_: {
  services.dashy = {
    enable = true;
    virtualHost = {
      domain = "0pt.icu";
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
            path = "https://blog.0pt.icu";
            title = "Blog";
          }
          {
            path = "https://chat.0pt.icu/";
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
                    title = "SearXNG";
                    url = "https://search.lkt.icu/?q=";
                  }
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
              title = "Syncthing";
              description = "Sync for everything";
              icon = "hl-syncthing";
              url = "https://sync.0pt.icu/";
              target = "newtab";
            }
            {
              title = "Immich";
              description = "Family DCIM";
              icon = "hl-immich";
              url = "https://pic.0pt.icu";
              target = "newtab";
            }
            {
              title = "Jellyfin";
              description = "The Free Software Media System";
              icon = "hl-jellyfin";
              url = "https://jellyfin.0pt.icu";
              target = "newtab";
            }
            {
              title = "Homebox";
              description = "A simple home inventory management software";
              icon = "hl-homebox";
              url = "https://homebox.0pt.icu";
              target = "newtab";
            }
            {
              title = "Cockpit";
              description = "Dashboard of the nas machine";
              icon = "hl-cockpit-light";
              url = "https://dashboard.0pt.icu";
              target = "newtab";
            }
            {
              title = "Forgejo";
              description = "Git Server in local";
              icon = "hl-forgejo";
              url = "https://git.0pt.icu";
              target = "newtab";
            }
            {
              title = "Alist";
              description = "File Client for the local";
              icon = "hl-alist";
              url = "https://alist.0pt.icu";
              target = "newtab";
            }
            {
              title = "Ariang";
              description = "A modern web frontend making aria2 easier to use.";
              icon = "hl-ariang";
              url = "https://aria2.0pt.icu";
              target = "newtab";
            }
            {
              title = "Wakapi";
              description = "Seft-built Code Stat";
              icon = "hl-wakapi";
              url = "https://wakapi.0pt.icu";
              target = "newtab";
            }
            {
              title = "Gotify";
              description = "Seft-built notification server";
              icon = "hl-gotify";
              url = "https://gotify.0pt.icu";
              target = "newtab";
            }
            {
              title = "Glances";
              description = "Monitor yourself";
              icon = "hl-glances-light";
              url = "https://glances.0pt.icu";
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
                hostname = "https://glances.0pt.icu";
              };
            }
            {
              type = "gl-current-mem";
              options = {
                hostname = "https://glances.0pt.icu";
              };
            }
            {
              type = "gl-alerts";
              options = {
                hostname = "https://glances.0pt.icu";
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
                hostname = "https://glances.0pt.icu";
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
                hostname = "https://glances.0pt.icu";
                limit = 60;
              };
            }
            {
              type = "gl-mem-history";
              options = {
                hostname = "https://glances.0pt.icu";
                limit = 80;
              };
            }
            {
              type = "gl-load-history";
              options = {
                hostname = "https://glances.0pt.icu";
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
                hostname = "https://glances.0pt.icu";
              };
            }
            {
              type = "gl-disk-io";
              options = {
                hostname = "https://glances.0pt.icu";
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
}
