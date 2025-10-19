_: {
  virtualisation.oci-containers.containers."goatcounter" = {
    image = "arp242/goatcounter:latest";
    volumes = [
      "goatcounter:/home/goatcounter/goatcounter-data:rw"
    ];
    ports = [
      "127.0.0.1:8082:8080"
    ];
  };
}
