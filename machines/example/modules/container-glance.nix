_: {
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.oci-containers.containers."glance" = {
    image = "glanceapp/glance:latest";
    volumes = [
      "glance:/app/config:rw"
      "/var/run/docker.sock:/var/run/docker.sock"
    ];
    ports = [
      "127.0.0.1:8080:8080"
    ];
    labels = {
      "glance.name" = "glance";
      "glance.icon" = "sh:glance";
      "glance.url" = "https://glance.example.com";
      "glance.description" = "Dashboard";
    };
  };
}
