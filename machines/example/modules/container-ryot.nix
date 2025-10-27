_: {
  virtualisation.oci-containers.containers."ryot" = {
    pull = "newer";
    image = "ghcr.io/ignisda/ryot:latest";
    dependsOn = [
      "postgres"
    ];
    environment = {
      "TZ" = "Asia/Singapore";
      "DATABASE_URL" = "postgres://xxx";
      "FRONTEND_URL" = "https://ryot.example.com";
      "RUST_LOG" = "ryot=debug";
      "SERVER_ADMIN_ACCESS_TOKEN" = "xxx";
      "ANIME_AND_MANGA_MAL_CLIENT_ID" = "xxx";
      "MOVIES_AND_SHOWS_TMDB_ACCESS_TOKEN" = "xxx";
      "MOVIES_TMDB_LOCALE" = "en";
      "SHOWS_TMDB_LOCALE" = "en";
      "SERVER_IMPORTER_TRAKT_CLIENT_ID" = "xxx";
      "VIDEO_GAMES_TWITCH_CLIENT_ID" = "xxx";
      "VIDEO_GAMES_TWITCH_CLIENT_SECRET" = "xxx";
    };
    ports = [
      "127.0.0.1:18000:8000/tcp"
    ];
  };
}
