{nix-homebrew, ...}: [
  nix-homebrew.darwinModules.nix-homebrew
  {
    nix-homebrew = {
      enable = true;
      user = "joaquin";
      # also install Homebrew under the default Intel prefix for Rosetta 2 (if Rosetta installed)
      # enableRosetta = true;
      # with mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
      # mutableTaps = false;
    };
  }
]
