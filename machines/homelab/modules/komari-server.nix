_: {
  services.komari-server = {
    enable = false;
    host = "127.0.0.1";
    port = "25774";
    openFirewall = true;
    environmentFile = /tmp/secret;
  };
}
