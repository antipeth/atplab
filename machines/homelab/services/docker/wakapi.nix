{
  image = "ghcr.io/muety/wakapi:latest";

  volumes = [
    "/etc/wakapi:/data"
    "/etc/localtime:/etc/localtime:ro"
  ];

  ports = [
    # forgejo use 3000 port.
    "127.0.0.1:3001:3000"
  ];
  # this is for test

  environment = {
    WAKAPI_PASSWORD_SALT = "-";
    WAKAPI_ALLOW_SIGNUP = "false";
    WAKAPI_PUBLIC_URL = "https://your-wakapi-domain";
  };

  user = "root";
}
