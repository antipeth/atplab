_: {
  services.cockpit = {
    enable = true;
    port = 9090;
    settings = {
      WebService = {
        Origins = "https://monitor.0pt.icu";
        ProtocolHeader = "X-Forwarded-Proto";
        ForwardedForHeader = "X-Forwarded-For";
        LoginTitle = "Monitor";
      };
    };
  };
}
