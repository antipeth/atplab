''
  protocol bgp dn42_atp_octopus_v4 from dnpeers {
      neighbor 172.20.192.1 as 4242420003;
      direct;
      ipv6 {
          import none;
          export none;
      };
  };

  protocol bgp dn42_atp_octopus_v6 from dnpeers {
      neighbor fd25:5547:5a89::1 % 'dn42-atp' as 4242420003;
      direct;
      ipv4 {
          import none;
          export none;
      };
  };
''
