{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    btop
    curl
    fastfetch
    git
    helix
    lsof
    wget
    zellij
    zoxide
  ];
  programs.bash = {
    interactiveShellInit = ''
      eval "$(zoxide init bash)"
    '';
  };
}
