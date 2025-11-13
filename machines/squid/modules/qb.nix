{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.qbittorrent;
in {
  services = {
    qbittorrent = {
      enable = true;
      package = pkgs.qbittorrent-enhanced-nox;
      profileDir = "/var/lib/qBittorrent/";
      webuiPort = 28080;
      torrentingPort = 56881;
      serverConfig = {
        Application = {
          FileLogger = {
            Age = 14;
            AgeType = 0;
            Backup = true;
            DeleteOld = true;
            Enabled = true;
            MaxSizeBytes = 66560;
            Path = "${cfg.profileDir}qBittorrent/data/logs";
          };
          MemoryWorkingSetLimit = 1024;
        };
        AutoRun = {
          enabled = false;
          program = "";
        };
        BitTorrent = {
          Session = {
            AddExtensionToIncompleteFiles = true;
            AddTorrentStopped = false;
            AddTrackersEnabled = true;
            DefaultSavePath = "${cfg.profileDir}qBittorrent/downloads";
            ExcludedFileNames = "";
            FinishedTorrentExportDirectory = "";
            GlobalMaxInactiveSeedingMinutes = 6000;
            GlobalMaxRatio = 3;
            MaxActiveCheckingTorrents = 1;
            MaxActiveDownloads = 5;
            MaxActiveTorrents = 10;
            MaxActiveUploads = 5;
            MaxConnections = 800;
            MaxUploadsPerTorrent = 10;
            Port = cfg.torrentingPort;
            QueueingSystemEnabled = false;
            SSL = {
              Enabled = true;
              Port = cfg.torrentingPort + 1;
            };
            ShareLimitAction = "Stop";
            TempPath = "";
            TorrentExportDirectory = "";
            TorrentStopCondition = "MetadataReceived";
            UseAlternativeGlobalSpeedLimit = false;
            uTPRateLimited = false;
          };
        };
        Core = {
          AutoDeleteAddedTorrentFile = "Never";
        };
        LegalNotice = {
          Accepted = true;
        };
        Meta = {
          MigrationVersion = 8;
        };
        Network = {
          PortForwardingEnabled = true;
          Proxy = {
            HostnameLookupEnabled = true;
            Profiles = {
              BitTorrent = true;
              Misc = true;
              RSS = true;
            };
          };
        };
        Preferences = {
          Connection = {
            PortRangeMin = cfg.torrentingPort;
            UPnP = true;
          };
          Downloads = {
            SavePath = "${cfg.profileDir}qBittorrent/downloads";
            TempPath = "";
          };
          General = {
            Locale = "en_US";
          };
          MailNotification = {
            req_auth = true;
          };
          WebUI = {
            Address = "*";
            AlternativeUIEnabled = true;
            AuthSubnetWhitelist = "@Invalid()";
            AuthSubnetWhitelistEnabled = false;
            Password_PBKDF2 = import ../values/qb-passwd.nix;
            RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
            ServerDomains = "*";
            SessionTimeout = 360000;
            TrustedReverseProxiesList = "127.0.0.1/8";
            Username = import ../values/qb-user.nix;
          };
        };
        RSS = {
          AutoDownloader = {
            DownloadRepacks = true;
            SmartEpisodeFilter = ''
              s(\\d+)e(\\d+), (\\d+)x(\\d+), "(\\d{4}[.\\-]\\d{1,2}[.\\-]\\d{1,2})", "(\\d{1,2}[.\\-]\\d{1,2}[.\\-]\\d{4})"
            '';
          };
        };
      };
    };
    openlist = {
      enable = true;
      user = cfg.user;
      group = cfg.group;
    };
    nginx.virtualHosts = {
      "qbee.0pt.dpdns.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
        extraConfig = ''
          proxy_hide_header X-Powered-By;
          proxy_hide_header Server;
        '';
        locations."/" = {
          proxyPass = "http://unix:${config.services.anubis.instances.qb.settings.BIND}:";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };
      "ol.0pt.dpdns.org" = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
        extraConfig = ''
          proxy_hide_header X-Powered-By;
          proxy_hide_header Server;
        '';
        locations."/" = {
          proxyPass = "http://unix:${config.services.anubis.instances.openlist.settings.BIND}:";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_buffering off;
            client_max_body_size 2000m;
          '';
        };
      };
    };
    anubis.instances.qb.settings.TARGET = "http://127.0.0.1:${toString cfg.webuiPort}";
    anubis.instances.openlist.settings.TARGET = "http://127.0.0.1:5244";
  };
  networking.firewall.allowedTCPPorts = [cfg.torrentingPort];
}
