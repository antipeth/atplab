{
  pkgs,
  config,
  ...
}: {
  services.forgejo = {
    enable = true;
    database.type = "postgres";
    package = pkgs.forgejo;
    # Enable support for Git Large File Storage
    lfs.enable = true;
    settings = {
      DEFAULT = {
        APP_NAME = "ATP's Nas git";
        APP_SLOGAN = "Where is my 🧊?";
      };
      "repository.issue" = {
        MAX_PINNED = 10;
      };
      "repository.upload" = {
        FILE_MAX_SIZE = 1024;
        MAX_FILES = 100;
      };
      ui = {
        DEFAULT_THEME = "forgejo-dark";
        THEMES = "forgejo-dark";
      };
      "ui.meta" = {
        AUTHOR = "ATP";
        DESCRIPTION = "How about use the 🧊?";
      };
      server = {
        DOMAIN = "git.0pt.icu";
        # You need to specify this to remove the port from URLs in the web UI.
        ROOT_URL = "https://${config.services.forgejo.settings.server.DOMAIN}/";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
        DISABLE_SSH = false;
        SSH_PORT = import ../../../sops/eval/homelab/forgejo-ssh-port.nix;
        START_SSH_SERVER = true;
      };
      admin = {
        DEFAULT_EMAIL_NOTIFICATIONS = "disabled";
        DISABLE_REGULAR_ORG_CREATION = true;
      };
      openid = {
        ENABLE_OPENID_SIGNIN = false;
      };
      service = {
        # You can temporarily allow registration to create an admin user.
        DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = true;
        DEFAULT_ALLOW_CREATE_ORGANIZATION = true;
        DEFAULT_USER_IS_RESTRICTED = true;
      };
      "service.explore" = {
        REQUIRE_SIGNIN_VIEW = true;
      };
      oauth2 = {
        ENABLED = false;
      };
      i18n = {
        LANGS = "en-US";
        NAMES = "English";
      };
      # Add support for actions, based on act: https://github.com/nektos/act
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
    };
  };
  networking.firewall.allowedTCPPorts = [
    (import ../../../sops/eval/homelab/forgejo-ssh-port.nix)
  ];
}
