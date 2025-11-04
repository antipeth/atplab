{pkgs, ...}: {
  services.garage = {
    enable = true;
    package = pkgs.garage_2;
    settings = {
      db_engine = "lmdb";
      consistency_mode = "consistent";
      replication_factor = 1;
      compression_level = 2;
      # Generate by `openssl rand -hex 32`
      rpc_secret = "xxx";
      rpc_bind_addr = "127.0.0.1:3901";
      rpc_public_addr = "127.0.0.1:3901";
      s3_api = {
        api_bind_addr = "127.0.0.1:3900";
        s3_region = "us-west-2";
        root_domain = ".garage.example.com";
      };
      s3_web = {
        bind_addr = "127.0.0.1:3902";
        root_domain = ".garageweb.example.com";
        index = "index.html";
      };
      admin = {
        api_bind_addr = "127.0.0.1:3903";
        # Generate by `openssl rand -base64 32`
        admin_token = "xxx";
        # Generate by `openssl rand -base64 32`
        metrics_token = "xxx";
      };
    };
  };
}
