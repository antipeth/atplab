_: {
  services.gatus.settings.endpoints = let
    servicesList = [
      {
        name = "actual";
        url = "https://actual.0pt.dpdns.org";
      }
      {
        name = "aria2";
        url = "https://ariang.0pt.dpdns.org";
      }
      {
        name = "garage-webui";
        url = "https://garage-ui.0pt.dpdns.org";
      }
      {
        name = "grafana";
        url = "https://grafana.0pt.dpdns.org";
      }
      {
        name = "kavita";
        url = "https://kavita.0pt.dpdns.org";
      }
      {
        name = "komari-server";
        url = "https://eye.0pt.dpdns.org";
      }
      {
        name = "microbin";
        url = "https://microbin.0pt.dpdns.org";
      }
      {
        name = "minio-ui";
        url = "https://minio-ui.0pt.dpdns.org";
      }
      {
        name = "openlist";
        url = "https://openlist.0pt.dpdns.org";
      }
      {
        name = "qb-for-pt";
        url = "https://qb.0pt.dpdns.org";
      }
      {
        name = "radicale";
        url = "https://radicale.0pt.dpdns.org";
      }
      {
        name = "wakapi";
        url = "https://wakapi.0pt.dpdns.org";
      }
    ];
    toEndpoint = svc:
      svc
      // {
        group = "octopus";
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
