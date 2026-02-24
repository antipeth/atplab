{config, ...}: let
  cfg = config.services.bird-lg;
in {
  services = {
    bird-lg = {
      frontend = {
        enable = true;
        listenAddresses = "127.0.0.1:5000";
        proxyPort = 8000;
        domain = "";
        servers = ["TestName<127.0.0.1>"];
        netSpecificMode = "dn42";
        protocolFilter = ["bgp"];
        extraArgs = ["--trust-proxy-headers"];
      };
      proxy = {
        enable = true;
        listenAddresses = "127.0.0.1:${toString cfg.frontend.proxyPort}";
      };
    };
  };
}
