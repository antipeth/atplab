_: let
  user = "samba";
in {
  services = {
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "public" = {
          "path" = "/test/public";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = user;
        };
        "private" = {
          "path" = "/test/private";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = user;
          "writeable" = "yes";
        };
      };
    };
    avahi = {
      enable = true;
      publish.enable = true;
      publish.userServices = true;
      nssmdns4 = true;
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
    discovery = true;
  };

  networking.firewall.allowPing = true;
  users.users.${user} = {
    name = user;
    group = user;
    isSystemUser = true;
  };
  users.groups.${user} = {};
}
