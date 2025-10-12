_: {
  services = {
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      guiAddress = "localhost:8384";
      settings = {
        devices = {
          device-name-1 = {
            id = "PNXRTAP-3SZD1AF-KHARSWZ-6YBM4P6-XUV1AN2-2HEAUFQ-3Y7Z2UM-JAN6GQV";
          };
          device-name-2 = {
            id = "OP5TTKB-AI2JAB0-6YBI2Q4-XHHFAQQ-Q8O21VV-5QZB3XW-5MAM42F-B174AQZ";
          };
        };
        folders = {
          "/var/lib/Sync" = {
            id = "default";
            devices = [
              "device-name-1"
              "device-name-2"
            ];
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
