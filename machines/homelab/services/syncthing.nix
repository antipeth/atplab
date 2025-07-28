_: {
  services = {
    syncthing = {
      enable = true;
      dataDir = "/backup";
      user = "atp";
      group = "users";
      openDefaultPorts = true;
      guiAddress = "localhost:8384";
      settings = {
        # devices = {
        #   asusbook = {
        #     id = "PNXRTAP-4SZD2AF-KHARWWZ-6YBM4P6-XUV2AN2-2HEAUFQ-LY7Z2UM-JANGGQV";
        #   };
        #   PostmarketOS = {
        #     id = "OP5TTKB-AI2JABB-6YBI2Q4-XHHFAQQ-QHO23VV-5QZBMXW-5MAM42F-BX74AQZ";
        #   };
        # };
        folders = {
          "/backup/sync" = {
            id = "default";
            # devices = [
            #   "asusbook"
            #   "PostmarketOS"
            # ];
            versioning.type = "trashcan";
          };
        };
        options = {
          globalAnnounceEnabled = false;
          localAnnounceEnabled = true;
          relaysEnabled = false;
        };
      };
    };
  };
}
