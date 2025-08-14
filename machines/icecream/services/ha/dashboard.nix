{
  title = "Home Assistant Demo";
  views = [
    {
      type = "sections";
      title = "Demo";
      path = "home";
      icon = "mdi:home-assistant";
      badges = [
        {
          type = "entity";
          entity = "sensor.outdoor_temperature";
          color = "red";
        }
        {
          type = "entity";
          entity = "sensor.outdoor_humidity";
          color = "indigo";
        }
        {
          type = "entity";
          entity = "device_tracker.car";
        }
      ];
      sections = [
        {
          type = "grid";
          cards = [
            {
              type = "heading";
              heading = "书房";
              icon = "mdi:desk-lamp";
            }
            {
              type = "tile";
              entity = "device_tracker.asusbook";
              name = "Asusbook";
            }
            {
              type = "tile";
              entity = "device_tracker.homelab";
              name = "Homelab";
            }
            {
              type = "tile";
              entity = "device_tracker.icecream";
              name = "Icecream";
            }
          ];
        }
      ];
    }
  ];
}
