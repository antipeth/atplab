_: {
  services.restic.server = {
    enable = true;
    htpasswd-file = /run/secret;
    listenAddress = "127.0.0.1:8081";
  };
}
