{...}: {
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # enable this so nix-darwin creates a zshrc sourcing needed environment changes
    zsh.enable = true;
  };
}
