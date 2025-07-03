{
  image = "rommapp/romm:latest";

  volumes = [
    "romm:/romm" # 挂载卷
  ];

  ports = [
    "127.0.0.1:18080:8080" # 暴露的端口
  ];

  environment = {
    ROMM_DB_DRIVER = "postgresql";
    DB_HOST = "";
    DB_NAME = "romm";
    DB_USER = "romm";
    DB_PASSWD = "";
    ROMM_AUTH_SECRET_KEY = "9094bcfecb6dd7b4a55ca71f2dbc1ee929edd67d71f067d4880d3def3532f7b2";
  };
}
