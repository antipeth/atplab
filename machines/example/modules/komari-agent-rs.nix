_: {
  services.komari-agent-rs = {
    enable = true;
    token = "xxxxxx";
    endpoint = "http://127.0.0.1:25774";
    extraFlags = "-f 10";
  };
}
