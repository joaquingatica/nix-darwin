{pkgs, inputs, ...}: let
  inherit (inputs) self;
in {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =[
    # pkgs.vim
  ];

  homebrew = {
    enable = true;
    brews = [
      # add brews here
    ];
    casks = [
      # add casks here
    ];
    onActivation = {
      autoUpdate = true;
      # uncomment to remove packages not listed above
      # cleanup = "uninstall";
    };
  };

  nix = {
    distributedBuilds = false;

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 2;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };

    linux-builder = {
      enable = false;
      maxJobs = 4;
      config = {
        virtualisation.cores = 4;
      };
    };

    settings = {
      # https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = pkgs.stdenv.isLinux;
      # Necessary for using flakes on this system.
      experimental-features = "nix-command flakes";
      trusted-users = [ "root" "joaquin" ];
    };
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # enable this so nix-darwin creates a zshrc sourcing needed environment changes
    zsh.enable = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  system = {
    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };
    };

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };
}
