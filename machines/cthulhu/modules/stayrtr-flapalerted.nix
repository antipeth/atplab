_: {
  services = {
    stayrtr-flapalerted = {
      enable = true;
      settings = {
        bind = "127.0.0.1:8083";
        metricsAddr = "127.0.0.1:8084";
        cache = "http://127.0.0.1:8080/flaps/active/roa";
        rtrExpire = 3600;
        rtrRefresh = 300;
        rtrRetry = 300;
      };
    };
    dn42.bgpTemplate = ''
      # --- stayrtr-flapalerted ---
      roa4 table roa_flap_v4;
      roa6 table roa_flap_v6;

      protocol rpki rpki_flapalerted {
        roa4 { table roa_flap_v4; };
        roa6 { table roa_flap_v6; };
        remote 127.0.0.1 port 8083;
        max version 1;
        retry keep 10;
      };

      template bgp dnpeers {
        local as OWNAS;
        path metric 1;

        ipv4 {
          import filter {
            if is_valid_network() && !is_self_net() then {
              # --- stayrtr-flapalerted filter ---
              if (roa_check(roa_flap_v4, net, bgp_path.last) = ROA_INVALID) then {
                reject;
              }
              if (roa_check(dn42_roa, net, bgp_path.last) != ROA_VALID) then {
                print "[dn42] ROA check failed for ", net, " ASN ", bgp_path.last;
                reject;
              } else accept;
            } else reject;
          };

          export filter {
            if is_valid_network() && source ~ [RTS_STATIC, RTS_BGP] then accept;
            else reject;
          };

          import limit 9000 action block;
        };

        ipv6 {
          import filter {
            if is_valid_network_v6() && !is_self_net_v6() then {
              # --- stayrtr-flapalerted filter ---
              if (roa_check(roa_flap_v6, net, bgp_path.last) = ROA_INVALID) then {
                reject;
              }
              if (roa_check(dn42_roa_v6, net, bgp_path.last) != ROA_VALID) then {
                print "[dn42] ROA check failed for ", net, " ASN ", bgp_path.last;
                reject;
              } else accept;
            } else reject;
          };

          export filter {
            if is_valid_network_v6() && source ~ [RTS_STATIC, RTS_BGP] then accept;
            else reject;
          };

          import limit 9000 action block;
        };
      }
    '';
  };
}
