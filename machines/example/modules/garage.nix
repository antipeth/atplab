{pkgs, ...}: {
  services.garage = {
    enable = true;
    package = pkgs.garage;
    settings = {
      consistency_mode = "consistent";
      replication_factor = 3;
      rpc_secret = "The5b8iHZzOGcr3o5QEkY6HsJdlSGEdCea18QV0j";
      rpc_bind_addr = "127.0.0.1:3901";
      s3_api = {
        api_bind_addr = "127.0.0.1:3900";
        s3_region = "us-west-2";
        root_domain = ".garage.example.com";
      };
      s3_web = {
        bind_addr = "127.0.0.1:3902";
        root_domain = ".garageweb.example.com";
      };
    };
  };
}
