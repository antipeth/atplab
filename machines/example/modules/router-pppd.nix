_: {
  # setup pppoe session
  services.pppd = {
    enable = true;
    peers = {
      edpnet = {
        # Autostart the PPPoE session on boot
        autostart = true;
        enable = true;
        config = ''
          plugin rp-pppoe.so wan

          # pppd supports multiple ways of entering credentials,
          # this is just 1 way
          name "${secrets.pppoe.username}"
          password "${secrets.pppoe.pass}"

          persist
          maxfail 0
          holdoff 5

          noipdefault
          defaultroute
        '';
      };
    };
  };
}
