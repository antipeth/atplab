_: {
  services.gatus.settings.endpoints = let
    servicesList = [
      {
        name = "actual";
        url = "https://actual.0pt.dpdns.org";
      }
      {
        name = "akkoma";
        url = "https://akkoma.0pt.dpdns.org";
      }
      {
        name = "aria2";
        url = "https://ariang.0pt.dpdns.org";
      }
      {
        name = "conduit";
        url = "https://ariang.0pt.dpdns.org";
      }
      {
        name = "garage";
        url = "https://garage.0pt.dpdns.org";
      }
      {
        name = "garage-ui";
        url = "https://garage-ui.0pt.dpdns.org";
      }
      {
        name = "grafana";
        url = "https://grafana.0pt.dpdns.org";
      }
      {
        name = "headscale";
        url = "https://hs.0pt.dpdns.org/windows";
      }
      {
        name = "headscale-ui";
        url = "https://hs.0pt.dpdns.org/web/";
      }
      {
        name = "kanidm";
        url = "https://kanidm.0pt.dpdns.org";
      }
      {
        name = "karakeep";
        url = "https://karakeep.0pt.dpdns.org";
      }
      {
        name = "kavita";
        url = "https://kavita.0pt.dpdns.org";
      }
      {
        name = "lemmy";
        url = "https://lemmy.0pt.dpdns.org";
      }
      {
        name = "microbin";
        url = "https://microbin.0pt.dpdns.org";
      }
      {
        name = "miniflux";
        url = "https://miniflux.0pt.dpdns.org";
      }
      {
        name = "minio";
        url = "https://minio.0pt.dpdns.org";
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
        name = "qbitorrent";
        url = "https://qb.0pt.dpdns.org";
      }
      {
        name = "radicale";
        url = "https://radicale.0pt.dpdns.org";
      }
      {
        name = "readeck";
        url = "https://readeck.0pt.dpdns.org";
      }
      {
        name = "umami";
        url = "https://umami.0pt.dpdns.org";
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
          "[STATUS] == any(200, 401, 403)"
          "[RESPONSE_TIME] < 5000"
        ];
        alerts = [{type = "gotify";}];
      };
  in
    map toEndpoint servicesList;
}
