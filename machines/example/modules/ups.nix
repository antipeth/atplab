{pkgs, ...}: {
  services.apcupsd = {
    enable = true;
    configText = ''
      UPSTYPE usb
      NISIP 127.0.0.1

      BATTERYLEVEL 70
      MINUTES 5
      TIMEOUT 60
    '';
    hooks = {
      doshutdown = ''
        ${pkgs.curl}/bin/curl "http://127.0.0.1:1245/message?token=AkFEQLUQdbIP7yG" \
          -F "title=UDP auto shutdown" \
          -F "message=Your homelab shutdown now" \
          -F "priority=1"
      '';
    };
  };
}
