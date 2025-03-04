{
  services.glances = {
    enable = true;
    extraArgs = [
      "--webserver"
      "--disable-webui"
    ];
    port = 61208;
  };
}
