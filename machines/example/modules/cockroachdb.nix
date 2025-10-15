{pkgs, ...}: {
  services.cockroachdb = {
    enable = true;
    listen.address = "ip-1";
    openPorts = true;
    join = "ip-1,ip-2,ip-3";
    insecure = true;
    package = pkgs.cockroachdb-bin;
  };
}
