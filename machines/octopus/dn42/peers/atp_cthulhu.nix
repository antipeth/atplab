''
  protocol bgp dn42_atp_cthulhu_v4 from dnpeers {
      neighbor 172.20.192.3 as 4242420003;
      direct;
      ipv6 {
          import none;
          export none;
      };
  };

  protocol bgp dn42_atp_cthulhu_v6 from dnpeers {
      neighbor fd25:5547:5a89::3 % 'dn42-atp' as 4242420003;
      direct;
      ipv4 {
          import none;
          export none;
      };
  };
''
