_: {
  virtualisation.oci-containers.containers."miniflux" = {
    pull = "newer";
    image = "ghcr.io/miniflux/miniflux:latest";
    environment = {
      RUN_MIGRATIONS = "1";
      DATABASE_URL = "postgres://miniflux:password@dbhost/miniflux?sslmode=disabl";
      BASE_URL = "https://rss.example.com/";
      CREATE_ADMIN = "1";
      ADMIN_USERNAME = "username";
      ADMIN_PASSWORD = "password";
    };
    ports = [
      "127.0.0.1:18081:8080"
    ];
  };
}
