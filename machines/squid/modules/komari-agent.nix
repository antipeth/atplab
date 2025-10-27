_: {
  services.komari-agent = {
    enable = true;
    token = import ../values/komari-token.nix;
    endpoint = "https://eye.0pt.dpdns.org";
    disableAutoUpdate = true;
    disableWebSsh = true;
    extraFlags = "--include-mountpoint /nix --interval 5.0 --max-retries 5 --reconnect-interval 10 --info-report-interval 15";
  };
}
