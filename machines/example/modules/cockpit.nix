_: {
  services.cockpit = {
    enable = true;
    port = 9090;
    settings = {
      WebService = {
        Origins = "https://dashboard.example.com";
        ProtocolHeader = "X-Forwarded-Proto";
        ForwardedForHeader = "X-Forwarded-For";
        LoginTitle = "dashboard for the nas";
      };
    };
  };
}
