{config, ...}: {
  # Intel AX101
  services.hostapd = {
    enable = true;
    radios = {
      wlan0 = {
        band = "2g";
        channel = 11; # ACS

        wifi6.enable = true;

        networks = {
          wlan0 = {
            ssid = "test";
            authentication = {
              mode = "wpa3-sae";
              saePasswordsFile = config.sops.secrets.icecream-wifi-password.path;
            };
            # bssid = "36:b9:ff:ff:ff:ff";
          };
        };
      };
    };
  };
}
