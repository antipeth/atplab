{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    btop
    curl
    fastfetch
    git
    lsof
    vim
    wget
    hdparm
    # openssl
  ];
}
