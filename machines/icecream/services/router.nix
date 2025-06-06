{
  boot.kernel.sysctl = {
    # if you use ipv4, this is all you need
    "net.ipv4.conf.all.forwarding" = true;

    # If you want to use it for ipv6
    "net.ipv6.conf.all.forwarding" = true;

    # source: https://github.com/mdlayher/homelab/blob/master/nixos/routnerr-2/configuration.nix#L52
    # By default, not automatically configure any IPv6 addresses.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;
  };
  networking = {
    firewall.enable = false;
    interfaces = {
      eth0 = {
        useDHCP = true;
      };
      eth1 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "10.13.10.1";
            prefixLength = 24;
          }
        ];
      };
    };
    # nftables = {
    #   ruleset = ''
    #     table ip filter {
    #       chain input {
    #         type filter hook input priority 0; policy drop;
    #
    #         iifname { "eth1" } accept comment "Allow local network to access the router"
    #         iifname "eth0" ct state { established, related } accept comment "Allow established traffic"
    #         iifname "eth0" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
    #         iifname "eth0" counter drop comment "Drop all other unsolicited traffic from wan"
    #       }
    #       chain forward {
    #         type filter hook forward priority 0; policy drop;
    #         iifname { "eth1" } oifname { "eth0" } accept comment "Allow trusted LAN to WAN"
    #         iifname { "eth0" } oifname { "eth1" } ct state established, related accept comment "Allow established back to LANs"
    #       }
    #     }
    #     table ip nat {
    #       chain postrouting {
    #         type nat hook postrouting priority 100; policy accept;
    #         oifname "eth0" masquerade
    #       }
    #     }
    #     table ip6 filter {
    #      chain input {
    #         type filter hook input priority 0; policy drop;
    #       }
    #       chain forward {
    #         type filter hook forward priority 0; policy drop;
    #       }
    #     }
    #   '';
    # };
  };
}
