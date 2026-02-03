_: {
  services.gatus.settings.endpoints = let
    servicesList = [
      {
        name = "archivebox";
        url = "https://archivebox.0pt.dpdns.org";
      }
      {
        name = "atomic-server";
        url = "https://atomic.0pt.dpdns.org";
      }
      {
        name = "chartdb";
        url = "https://chartdb.0pt.dpdns.org";
      }
      {
        name = "convertx";
        url = "https://convertx.0pt.dpdns.org";
      }
      {
        name = "fusion";
        url = "https://fusion.0pt.dpdns.org";
      }
      {
        name = "glance";
        url = "https://glance.0pt.dpdns.org";
      }
      {
        name = "goatcounter";
        url = "https://goatcounter.0pt.dpdns.org";
      }
      {
        name = "libretranslate";
        url = "https://translate.0pt.dpdns.org";
      }
      {
        name = "miniflux";
        url = "https://miniflux.0pt.dpdns.org";
      }
      {
        name = "mozhi";
        url = "https://mozhi.0pt.dpdns.org";
      }
      {
        name = "myip";
        url = "https://myip.0pt.dpdns.org";
      }
      {
        name = "myspeed";
        url = "https://myspeed.0pt.dpdns.org";
      }
      {
        name = "omni-tools";
        url = "https://omni-tools.0pt.dpdns.org";
      }
      {
        name = "opengist";
        url = "https://opengist.0pt.dpdns.org";
      }
      {
        name = "openlist for bt";
        url = "https://ol.0pt.dpdns.org";
      }
      {
        name = "qbitorrent for bt";
        url = "https://qbee.0pt.dpdns.org/";
      }
      {
        name = "rsshub";
        url = "https://rsshub.0pt.dpdns.org";
      }
      {
        name = "rustpad";
        url = "https://rustpad.0pt.dpdns.org";
      }
      {
        name = "ryot";
        url = "https://ryot.0pt.dpdns.org";
      }
    ];
    toEndpoint = svc:
      svc
      // {
        group = "squid";
        interval = "1h";
        conditions = [
          "[STATUS] == any(200, 401)"
          "[RESPONSE_TIME] < 1000"
        ];
        alerts = [{type = "gotify";}];
      };
  in
    map toEndpoint servicesList;
}
