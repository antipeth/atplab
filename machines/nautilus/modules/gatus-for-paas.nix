_: {
  services.gatus.settings.endpoints = let
    servicesList = [
      {
        name = "Blog";
        url = "https://blog.0pt.icu";
      }
      {
        name = "Dashy Links";
        url = "https://links.0pt.icu";
      }
      {
        name = "kuma-mieru";
        url = "https://kuma-mieru.0pt.dpdns.org";
      }
      {
        name = "LibreTV";
        url = "https://tv.0pt.icu";
      }
      {
        name = "Lobe Chat";
        url = "https://chat.0pt.icu";
      }
    ];
    toEndpoint = svc:
      svc
      // {
        group = "PaaS";
        interval = "1h";
        conditions = [
          "[STATUS] == 200"
          "[RESPONSE_TIME] < 1000"
        ];
        alerts = [{type = "gotify";}];
      };
  in
    map toEndpoint servicesList;
}
