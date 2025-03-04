{
  services.cockpit = {
    enable = true;
    port = 9090;
    settings = {
      WebService = {
        Origins = "https://dashboard.0pt.us.kg";
        ProtocolHeader = "X-Forwarded-Proto";
        LoginTitle = "dashboard for the nas";
      };
    };
  };
}
