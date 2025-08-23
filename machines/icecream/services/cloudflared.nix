{config, ...}: {
  services.cloudflared = {
    enable = true;
    tunnels = {
      "ce8ef14e-03a1-414a-be70-a99323290720" = {
        credentialsFile = "${config.sops.secrets.icecream-cloudflared-creds.path}";
        default = "http_status:404";
      };
    };
  };
}
