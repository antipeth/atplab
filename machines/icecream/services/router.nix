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
    nftables = {
      ruleset = ''
        table ip filter {
          chain input {
            type filter hook input priority 0; policy drop;

            # Allow lo loopback
            iifname "lo" accept comment "Allow all loopback traffic"

            # Allow SSH on port from eth0
            iifname { "eth0", "usb0" } tcp dport 222 ct state new,established accept comment "Allow SSH"

            iifname { "eth1" } accept comment "Allow local network to access the router"
            iifname { "eth0", "usb0" } ct state { established, related } accept comment "Allow established traffic"
            iifname { "eth0", "usb0" } icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
            iifname { "eth0", "usb0" } counter drop comment "Drop all other unsolicited traffic from wan"
          }
          chain forward {
            type filter hook forward priority 0; policy drop;
            iifname { "eth1" } oifname { "eth0", "usb0"} accept comment "Allow trusted LAN"
            iifname { "eth0", "usb0" } oifname { "eth1" } ct state established, related accept comment "Allow established back to LANs"
          }
        }
        table ip nat {
          chain prerouting {
            type nat hook prerouting priority 0; policy accept;
          }
          chain postrouting {
            type nat hook postrouting priority 100; policy accept;
            oifname { "eth0", "usb0" } masquerade
          }
        }
        table ip6 filter {
         chain input {
            type filter hook input priority 0; policy drop;
          }
          chain forward {
            type filter hook forward priority 0; policy drop;
          }
        }
      '';
    };
  };
  services = {
    # DNS Settings
    unbound.settings = {
      access-control = ["10.13.10.0/24 allow" "::/0 refuse"];
      server.interface = [
        "0.0.0.0"
        "::0"
      ];
    };
    # DHCP server settings
    dnsmasq = {
      enable = true;
      resolveLocalQueries = false;
      settings = {
        # Shut down the dns server by settings port 0
        port = 0;

        # sensible behaviours
        domain-needed = true;
        bogus-priv = true;
        no-resolv = true;

        # Cache dns queries.
        cache-size = 1000;

        interface = "eth1";
        # bind-interfaces = true;
        dhcp-range = ["eth1,10.13.10.2,10.13.10.254,255.255.255.0,12h"];
        dhcp-host = "10.13.10.1";
        dhcp-option = [
          "option:router,10.13.10.1"
          "option:dns-server,10.13.10.1"
        ];
        expand-hosts = true;
        no-hosts = true;
      };
    };
  };
}
