{ config, ... }:
{
  services.minio = {
    enable = true;
    accessKey = import ../../../sops/eval/crystal/minio-access.nix;
    secretKey = import ../../../sops/eval/crystal/minio-secret.nix;
    region = import ../../../sops/eval/crystal/minio-region.nix;
    listenAddress = "127.0.0.1:9000";
    rootCredentialsFile = config.sops.secrets.crystal-minio-root-credentials.path;
  };
}
