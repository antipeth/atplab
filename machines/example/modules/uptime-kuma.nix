_: {
  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "127.0.0.1";
      PORT = "4000";
      # To fix the Node.js issue when initializing the database
      HOME = "/var/lib/uptime-kuma";
    };
  };
}
