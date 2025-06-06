{
  services.hostapd = {
    enable = true;
    radios = {
      wlan0 = {
        band = "2g";
        countryCode = "PL";
        channel = 0; # ACS

        wifi4.enable = true;

        networks = {
          wlan0 = {
            ssid = "wifi-name";
            authentication = {
              mode = "wpa3-sae";
              saePasswordsFile = "password";
            };
            bssid = "36:b9:ff:ff:ff:ff";
            settings = {
              bridge = "br-lan";
            };
          };
        };
      };
    };
  };
}
