_: {
  users.users.nginx.extraGroups = [
    "anubis"
  ];
  services.anubis = {
    defaultOptions = {
      botPolicy = {
        bots = [
          {
            name = "cloudflare-workers";
            headers_regex = {
              "CF-Worker" = ".*";
            };
            action = "DENY";
          }
          {
            name = "well-known";
            path_regex = "^/.well-known/.*$";
            action = "ALLOW";
          }
          {
            name = "favicon";
            path_regex = "^/favicon.ico$";
            action = "ALLOW";
          }
          {
            name = "robots-txt";
            path_regex = "^/robots.txt$";
            action = "ALLOW";
          }
          {
            name = "generic-browser";
            user_agent_regex = "Mozilla";
            action = "CHALLENGE";
          }
        ];
      };
    };
    instances = {
      gotify.settings.TARGET = "http://127.0.0.1:1245";
      openlist.settings.TARGET = "http://127.0.0.1:5244";
      wakapi.settings.TARGET = "http://127.0.0.1:3000";
    };
  };
}
