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
            name = "static-files";
            path_regex = "^/static/.*$";
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
  };
}
