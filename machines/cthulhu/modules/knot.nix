_: {
  services.knot = {
    enable = true;
    settings = {
      server = {
        listen = [
          "172.20.192.3@53"
          "fd25:5547:5a89::3@53"
        ];
      };
      template = [
        {
          id = "dn42";
          storage = "/etc/knot/dn42";
          file = "atp.dn42.zone";
        }
      ];
      zone = [
        {
          domain = "atp.dn42";
          template = "dn42";
        }
      ];
    };
  };
  environment.etc = {
    "knot/dn42/atp.dn42.zone" = {
      user = "knot";
      group = "knot";
      mode = "0400";
      text = ''
        $ORIGIN atp.dn42.
        $TTL 1h

        @   IN SOA ns1.atp.dn42. hostmaster.atp.dn42. (
                2025012001 ; serial
                1h         ; refresh
                15m        ; retry
                30d        ; expire
                2h         ; minimum
        )

            IN NS  ns1.atp.dn42.

        ns1 IN A     172.20.192.3
        ns1 IN AAAA  fd25:5547:5a89::3
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [53];
  networking.firewall.allowedUDPPorts = [53];
}
