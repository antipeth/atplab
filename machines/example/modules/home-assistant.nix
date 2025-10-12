{pkgs, ...}: {
  # !!! This is failure !!!

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "esphome"
      "met"
      "radio_browser"
      "shopping_list"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      # "isal"
      # "config"
      # "history"
      # "logbook"
      # "my"
      # "system_health"
      # "sun"
      # "shell_command"
    ];
    customComponents = with pkgs.home-assistant-custom-components; [
      xiaomi_miot
    ];
    # lovelaceConfig = {
    #   title = "My Awesome Home";
    #   views = [
    #     {
    #       title = "Example";
    #       cards = [
    #         {
    #           type = "markdown";
    #           title = "Lovelace";
    #           content = "Welcome to your **Lovelace UI**.";
    #         }
    #       ];
    #     }
    #   ];
    # };
    # customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
    #   mini-graph-card
    #   mini-media-player
    # ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/

      # config = { };
      # history = { };
      # logbook = { };
      # my = { };
      # system_health = { };
      # sun = { };
      # shell_command = {
      #   say_welcome_back = ''say "Welcome back"'';
      # };
      homeassistant = {
        name = "Home";
        latitude = "1.5";
        longitude = "103.5";
        elevation = 400;
        radius = 100;
        unit_system = "metric";
        temperature_unit = "C";
        time_zone = "Asia/Singapore";
        currency = "USD";
        external_url = "https://home.example.com";
        internal_url = "http://[::1]:8123";
        language = "en";
        debug = false;
      };
      frontend = {
        themes = {
          happy = {
            primary-color = "pink";
            text-primary-color = "purple";
          };
          sad = {
            primary-color = "steelblue";
            modes = {
              dark = {
                secondary-text-color = "slategray";
              };
            };
          };
          day_and_night = {
            primary-color = "coral";
            modes = {
              light = {
                secondary-text-color = "olive";
              };
              dark = {
                secondary-text-color = "slategray";
              };
            };
          };
        };
      };
      default_config = {};
      http = {
        server_host = "::1";
        server_port = 8123;
        trusted_proxies = ["::1"];
        use_x_forwarded_for = true;
      };
    };
  };
}
