''
  protocol bgp dn42_atp-squid_v4 from dnpeers {
      neighbor 172.20.192.2 as 4242420003;
      direct;
      ipv6 {
          import none;
          export none;
      };
  };

  protocol bgp dn42_atp-squid_v6 from dnpeers {
      neighbor fe80::b72b % 'dn42-atp' as 4242420003;
      direct;
      ipv4 {
          import none;
          export none;
      };
  };
''
