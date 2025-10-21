_: {
  services = {
    glance = {
      enable = true;
      settings = {
        server = {
          host = "127.0.0.1";
          port = 8083;
        };
        theme = {
          background-color = "240 21 15";
          contrast-multiplier = "1.2";
          primary-color = "217 92 83";
          positive-color = "115 54 76";
          negative-color = "347 70 65";
        };
        pages = [
          {
            name = "Home";
            columns = [
              {
                size = "small";
                widgets = [
                  {
                    type = "search";
                    search-engine = "duckduckgo";
                    bangs = [
                      {
                        title = "GitHub";
                        shortcut = "!gh";
                        url = "https://github.com/search?q={QUERY}";
                      }
                    ];
                  }
                  {
                    type = "calendar";
                    first-day-of-week = "monday";
                  }
                  {
                    type = "rss";
                    limit = 10;
                    collapse-after = 3;
                    cache = "12h";
                    feeds = [
                      {
                        url = "https://somebody.com/atom.xml";
                        title = "Blog";
                      }
                    ];
                  }
                  {
                    type = "group";
                    widgets = [
                      {
                        type = "hacker-news";
                      }
                      {
                        type = "lobsters";
                      }
                    ];
                  }
                ];
              }
              {
                size = "full";
                widgets = [
                  {
                    type = "rss";
                    limit = 25;
                    style = "horizontal-cards";
                    collapse-after = 3;
                    cache = "12h";
                    feeds = [
                      {
                        url = "https://selfh.st/rss/";
                        title = "selfh.st";
                        limit = 4;
                      }
                      {
                        url = "https://ciechanow.ski/atom.xml";
                      }
                      {
                        url = "https://www.joshwcomeau.com/rss.xml";
                        title = "Josh Comeau";
                      }
                      {
                        url = "https://samwho.dev/rss.xml";
                      }
                      {
                        url = "https://ishadeed.com/feed.xml";
                        title = "Ahmad Shadeed";
                      }
                    ];
                  }
                  {
                    type = "bookmarks";
                    style = "dynamic-columns-experimental";
                    groups = [
                      {
                        title = "Technology";
                        links = [
                          {
                            title = "GitHub";
                            url = "https://github.com";
                            icon = "si:github";
                          }
                          {
                            title = "Codeberg";
                            url = "https://codeberg.org";
                            icon = "si:codeberg";
                          }
                        ];
                      }
                    ];
                  }
                  {
                    type = "videos";
                    channels = [
                      "UCXuqSBlHAE6Xw-yeJA0Tunw" # Linus Tech Tips
                      "UCR-DXc1voovS8nhAvccRZhg" # Jeff Geerling
                      "UCsBjURrPoezykLs9EqgamOA" # Fireship
                      "UCBJycsmduvYEL83R_U4JriQ" # Marques Brownlee
                      "UCHnyfMqiRRG1u-2MsSQLbXA" # Veritasium
                    ];
                  }
                  {
                    type = "group";
                    widgets = [
                      {
                        type = "reddit";
                        subreddit = "technology";
                        show-thumbnails = true;
                      }
                      {
                        type = "reddit";
                        subreddit = "selfhosted";
                        show-thumbnails = true;
                      }
                    ];
                  }
                ];
              }
              {
                size = "small";
                widgets = [
                  {
                    type = "weather";
                    location = "Temasek, Singapore";
                    units = "metric";
                    hour-format = "24h";
                    hide-location = true;
                  }
                  {
                    type = "clock";
                    hour-format = "24h";
                    timezones = [
                      {
                        timezone = "Asia/Tokyo";
                        label = "Tokyo";
                      }
                      {
                        timezone = "Asia/Singapore";
                        label = "Singapore";
                      }
                      {
                        timezone = "Europe/Moscow";
                        label = "Moscow";
                      }
                      {
                        timezone = "Europe/Paris";
                        label = "Paris";
                      }
                      {
                        timezone = "Europe/London";
                        label = "London";
                      }
                      {
                        timezone = "America/New_York";
                        label = "New York";
                      }
                    ];
                  }
                  {
                    type = "repository";
                    repository = "antipeth/atplab";
                  }
                  {
                    type = "to-do";
                  }
                ];
              }
            ];
          }
        ];
      };
    };
  };
}
