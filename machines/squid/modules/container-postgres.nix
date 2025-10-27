{config, ...}: {
  sops.secrets.squid-postgres-env = {
    mode = "0400";
    format = "binary";
    sopsFile = ../secrets/postgres-env;
  };
  virtualisation.oci-containers.containers."postgres" = {
    pull = "newer";
    image = "postgres:18-alpine";
    environmentFiles = [config.sops.secrets.squid-postgres-env.path];
    volumes = [
      "postgres:/var/lib/postgresql/data:rw"
    ];
    ports = [
      "127.0.0.1:5432:5432"
    ];
    labels = {
      "glance.name" = "postgres";
      "glance.icon" = "sh:postgres";
      "glance.description" = "Postgres";
    };
  };
}
