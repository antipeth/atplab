{ pkgs, ... }:
{
  services.garage = {
    enable = true;
    package = pkgs.garage;
    settings = {
      consistency_mode = "consistent";
      replication_factor = 3;
      rpc_secret = import ../../../sops/eval/crystal/minio-secret.nix;
      rpc_bind_addr = "127.0.0.1:3901";
      s3_api = {
        api_bind_addr = "127.0.0.1:3900";
        s3_region = import ../../../sops/eval/crystal/minio-region.nix;
        root_domain = "garage.0pt.icu";
      };
      s3_web = {
        bind_addr = "127.0.0.1:3902";
        root_domain = "garageweb.0pt.icu";
      };
    };
  };
}
