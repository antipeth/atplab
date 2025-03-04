{
  image = "xhofe/alist:latest";

  volumes = [
    "/etc/alist:/opt/alist/data" # 挂载卷
  ];

  ports = [
    "127.0.0.1:5244:5244" # 暴露的端口
  ];

  environment = {
    PUID = "0"; # 用户 ID
    PGID = "0"; # 组 ID
    UMASK = "022"; # 文件权限掩码
  };

}
