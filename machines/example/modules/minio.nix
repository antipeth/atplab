_: {
  services.minio = {
    enable = true;
    accessKey = "vn9HVH78mkhvg3mdd5Yd";
    secretKey = "DCM8Xx7bAsRI0VwMg3x8MmeuIbPbES62rNguJNiR";
    region = "us-east-2";
    listenAddress = "127.0.0.1:9000";
    rootCredentialsFile = /run/secret;
  };
}
