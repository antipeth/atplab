_: {
  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 8080;
    settings = {
      database.type = "sqlite";
      dns = {
        nameservers.global = [
          "127.0.0.1"
          "::1"
        ];
        base_domain = "test.test"; # magic_dns
        magic_dns = true;
        extra_records = [
          {
            name = "example.com";
            type = "A";
            value = "100.64.0.1";
          }
          {
            name = "glances.example.com";
            type = "A";
            value = "100.64.0.1";
          }
        ];
      };
      prefixes = {
        v4 = "100.64.0.0/10";
        allocation = "sequential";
      };
      server_url = "https://headscale.example.com";
    };
  };
}
