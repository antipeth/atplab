_: {
  services.home-assistant = {
    enable = false;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
      "luci"
      "open_meteo"
      # "wled"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};

      device_tracker = [
        {
          platform = "luci";
          host = "100.10.10.1";
          username = "ahnlgjie";
          password = "agldaskjih";
        }
      ];
      homeassistant = {
        name = "Home";
        latitude = 10;
        longitude = 10;
        elevation = 10;
        radius = 1000;
        unit_system = "metric";
        currency = "USD";
        country = "US";
        time_zone = "Asia/Singapore";
      };
      isal = {};
      # services.home-assistant.config.wled = {open_meteo = {};};
    };

    lovelaceConfig = import ./ha/dashboard.nix;
  };
}
