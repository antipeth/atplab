{
  services = {
    syncthing = {
      enable = true;
      dataDir = "/backup";
      user = "atp";
      group = "users";
      openDefaultPorts = true;
      guiAddress = "localhost:8384";
      settings = {
        devices = {
          asusbook = {
            id = "PNXRTAP-4SZD2AF-KHARWWZ-6YBM4P6-XUV2AN2-2HEAUFQ-LY7Z2UM-JANGGQV";
          };
        };
        folders = {
          "/backup/sync" = {
            id = "default";
            devices = [
              "asusbook"
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
  networking.firewall = {
    # for NFSv3; view with `rpcinfo -p`
    allowedTCPPorts = [
      8384
    ];
  };
}
