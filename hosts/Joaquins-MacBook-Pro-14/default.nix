{pkgs, inputs, ...}: let
  inherit (inputs) self;
in {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =[
    # pkgs.vim
  ];

  nix = {
    linux-builder = {
      enable = false;
      maxJobs = 4;
      config = {
        virtualisation.cores = 4;
      };
    };

    settings = {
      # Necessary for using flakes on this system.
      experimental-features = "nix-command flakes";
      trusted-users = [ "root" "joaquin" ];
    };
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  programs = {
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    # Create /etc/zshrc that loads the nix-darwin environment.
    zsh.enable = true; # default shell on catalina
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  system = {
    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };
}
