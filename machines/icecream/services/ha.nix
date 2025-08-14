_: {
  services.home-assistant = {
    enable = true;
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
          host = "10.110.10.1";
          username = "IIvJGracLwP59ILyJClGsJjsJ6";
          password = "IoNmVXZegt7AbK49SL0BxtCPGz";
        }
      ];
      homeassistant = {
        name = "Home";
        latitude = 10.0;
        longitude = 10.0;
        elevation = 10.0;
        radius = 100;
        unit_system = "metric";
        currency = "USD";
        country = "US";
        time_zone = "Asia/Singapore";
      };
      isal = {};
      zone = [
        {
          name = "Home";
          latitude = 10.0;
          longitude = 10.0;
          radius = 100;
          icon = "mdi:account-multiple";
        }
        {
          name = "School";
          latitude = 20.0;
          longitude = 20.0;
          radius = 100;
          icon = "mdi:school";
        }
      ];
    };

    lovelaceConfig = import ./ha/dashboard.nix;
  };
}
