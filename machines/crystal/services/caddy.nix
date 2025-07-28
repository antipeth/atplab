_: {
  services.caddy = {
    enable = true;
    virtualHosts."1.example.com" = {
      extraConfig = ''
        reverse_proxy localhost:8384 {
            header_up Host {upstream_hostport}
        }
      '';
    };
    virtualHosts."2.example.com" = {
      extraConfig = ''
        reverse_proxy localhost:19999 {
            header_up Host {upstream_hostport}
        }
      '';
    };
    virtualHosts."3.example.com" = {
      extraConfig = ''
        reverse_proxy localhost:5244 {
            header_up Host {upstream_hostport}
        }
      '';
    };
  };
}
