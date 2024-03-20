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

  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  system = {
    activationScripts.postUserActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    # see options: https://github.com/LnL7/nix-darwin/tree/bcc8afd06e237df060c85bad6af7128e05fd61a3/modules/system/defaults
    defaults = {
      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 3.0;
      };
      ActivityMonitor = {
        SortColumn = "CPUUsage";
        SortDirection = 0; # descending
      };
      dock = {
        autohide = true;
        largesize = 52;
        magnification = true;
        persistent-apps = [
          # add apps pinned to the dock
          # "/Applications/Firefox.app"
        ];
        show-recents = false;
        tilesize = 50;
        wvous-bl-corner = 2; # Mission Contro
        wvous-br-corner = 3; # Application Windows
        wvous-tl-corner = 1; # Disabled
        wvous-tr-corner = 12; # Notification Center
      };
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "clmv"; # Column View
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      magicmouse = {
        MouseButtonMode = "TwoButton";
      };
      menuExtraClock = {
        IsAnalog = false;
        Show24Hour = true;
        ShowAMPM = false;
        ShowDate = 0;
        ShowDayOfMonth = true;
        ShowDayOfWeek = true;
        ShowSeconds = false;
      };
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleTemperatureUnit = "Celsius";
        AppleWindowTabbingMode = "always";
        "com.apple.trackpad.scaling" = 3.0;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };
      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = true;
      };
    };

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };
}
