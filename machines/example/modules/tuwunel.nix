_: {
  services.matrix-tuwunel = {
    enable = true;
    settings = {
      global = {
        address = ["127.0.0.1"];
        port = [6167];
        server_name = "example.com";
        allow_federation = false;
        allow_registration = false;
        well_known = {
          client = "https://tuwunel.example.com";
          server = "tuwunel.example.com:443";
        };
      };
    };
  };
}
