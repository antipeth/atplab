{pkgs, ...}: {
  services = {
    akkoma = {
      enable = true;
      nginx = {
        forceSSL = true;
        kTLS = true;
        sslCertificate = "/etc/nginx/self-sign.crt";
        sslCertificateKey = "/etc/nginx/self-sign.key";
      };
      config = {
        ":pleroma" = {
          ":instance" = {
            name = "ATP's Akkoma instance";
            description = "This is 🧊!";
            email = "admin@example.com";
            registration_open = false;
          };
          "Pleroma.Web.Endpoint" = {
            url.host = "akkoma.0pt.dpdns.org";
          };
          # Media previews
          ":media_preview_proxy" = {
            enabled = true;
            thumbnail_max_width = 1920;
            thumbnail_max_height = 1080;
          };

          "Pleroma.Upload" = {
            base_url = "https://akkoma.0pt.dpdns.org/media/";
            filters =
              map (pkgs.formats.elixirConf {}).lib.mkRaw
              [
                "Pleroma.Upload.Filter.Exiftool"
                "Pleroma.Upload.Filter.Dedupe"
                "Pleroma.Upload.Filter.AnonymizeFilename"
              ];
          };
        };
      };
    };
  };
}
