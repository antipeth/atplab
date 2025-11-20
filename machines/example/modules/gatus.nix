_: {
  services.gatus = {
    enable = true;
    settings = {
      web = {
        address = "127.0.0.1";
        port = 8080;
      };
      endpoints = [
        {
          name = "service1";
          group = "tcp-example";
          url = "tcp://127.0.0.1:12345";
          interval = "5m";
          conditions = [
            "[CONNECTED] == true"
            "[RESPONSE_TIME] < 500"
          ];
          alerts = [{type = "gotify";}];
        }
        {
          name = "service2";
          group = "http-example";
          url = "https://services.example.com";
          interval = "5m";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 500"
          ];
          alerts = [{type = "gotify";}];
        }
      ];
      alerting.gotify = {
        server-url = "https://gotify.example";
        token = "gotify-tokens";
        priority = 5;
        default-alert = {
          description = "health check failed";
          send-on-resolved = true;
          failure-threshold = 5;
        };
      };
    };
  };
}
