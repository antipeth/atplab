_: {
  virtualisation.oci-containers.containers."zeroclaw" = {
    pull = "newer";
    image = "ghcr.io/zeroclaw-labs/zeroclaw:latest";
    volumes = [
      "zeroclaw:/zeroclaw-data:rw"
    ];
    environment = {
      "API_KEY" = "xxx";
      "ZEROCLAW_ALLOW_PUBLIC_BIND" = "true";
      "ZEROCLAW_MODEL" = "anthropic/claude-sonnet-4-20250514";
      "PROVIDER" = "openrouter";
    };
    ports = [
      "127.0.0.1:3000:3000"
    ];
  };
}
