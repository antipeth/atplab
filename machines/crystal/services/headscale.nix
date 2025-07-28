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
        base_domain = "test.test";
        magic_dns = true;
        extra_records = import ../../../sops/eval/crystal/headscale-dns-records.nix;
      };
      prefixes = {
        v4 = "100.64.0.0/10";
        allocation = "sequential";
      };
      server_url = "https://headscale.0pt.im";
    };
  };
}
