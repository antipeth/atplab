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
              heading = "Study room";
              icon = "mdi:desk-lamp";
            }
            {
              type = "tile";
              entity = "device_tracker.device1-name";
              name = "device1-name";
            }
            {
              type = "tile";
              entity = "device_tracker.device2-name";
              name = "device2-name";
            }
          ];
        }
      ];
    }
  ];
}
