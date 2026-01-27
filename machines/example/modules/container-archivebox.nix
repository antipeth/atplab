{config, ...}: {
  virtualisation.oci-containers.containers."archivebox" = {
    pull = "newer";
    image = "ghcr.io/archivebox/archivebox:latest";
    environment = {
      "LISTEN_HOST" = "127.0.0.1:8000";
      "ALLOWED_HOSTS" = "*";
      "CSRF_TRUSTED_ORIGINS" = "https://archivebox.example.com"; # MUST match the admin UI URL for login/API to work
      "PUBLIC_INDEX" = "False"; # set to False to prevent anonymous users from viewing snapshot list
      "PUBLIC_SNAPSHOTS" = "False"; # set to False to prevent anonymous users from viewing snapshot content
      "PUBLIC_ADD_VIEW" = "False"; # set to True to allow anonymous users to submit new URLs to archive
      "SEARCH_BACKEND_ENGINE" = "sqlite";
    };
    volumes = [
      "archivebox:/data:rw"
    ];
    ports = [
      "127.0.0.1:8002:8000"
    ];
    labels = {
      "glance.name" = "ArchiveBox";
      "glance.icon" = "sh:archivebox";
      "glance.description" = "Open source self-hosted web archiving.";
    };
  };
}
