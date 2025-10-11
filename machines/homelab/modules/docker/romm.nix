_: {
  virtualisation.oci-containers.containers.romm = {
    image = "ghcr.io/rommapp/romm:latest";

    volumes = [
      "romm_resources:/romm/resources"
      "romm_redis_data:/redis-data"
      "/media/romm/library:/romm/library"
      "/media/romm/assets:/romm/assets"
      "/media/romm/config:/romm/config"
    ];

    ports = [
      "127.0.0.1:8080:8080"
    ];

    extraOptions = ["--network=host"];

    environment = {
      ROMM_DB_DRIVER = "postgresql";
      DB_HOST = "127.0.0.1";
      DB_PORT = "5432";
      DB_NAME = "romm";
      DB_USER = "romm";
      DB_PASSWD = import ../../../../sops/eval/homelab/romm-db-passwd.nix;
      ROMM_AUTH_SECRET_KEY = import ../../../../sops/eval/homelab/romm-auth-secret-key.nix;
      IGDB_CLIENT_ID = import ../../../../sops/eval/homelab/romm-igdb-id.nix;
      IGDB_CLIENT_SECRET = import ../../../../sops/eval/homelab/romm-igdb-secret.nix;
    };
  };
}
