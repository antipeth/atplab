_: {
  services.gatus.settings.endpoints = let
    servicesList = [
      {
        name = "cyberchef";
        url = "https://cyberchef.0pt.dpdns.org";
      }
      {
        name = "gotify";
        url = "https://gotify.0pt.dpdns.org";
      }
      {
        name = "komari-server";
        url = "https://komari.0pt.dpdns.org";
      }
      {
        name = "searxng";
        url = "https://search.0pt.dpdns.org";
      }
      {
        name = "uptime-kuma";
        url = "https://uptime.0pt.dpdns.org";
      }
    ];
    toEndpoint = svc:
      svc
      // {
        group = "nautilus";
        interval = "1h";
        conditions = [
          "[STATUS] == any(200, 401)"
          "[RESPONSE_TIME] < 3000"
        ];
        alerts = [{type = "gotify";}];
      };
  in
    map toEndpoint servicesList;
}
