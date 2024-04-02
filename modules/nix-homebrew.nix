{
  nix-homebrew,
  homebrew-bundle,
  homebrew-cask,
  homebrew-core,
  ...
}: [
  nix-homebrew.darwinModules.nix-homebrew
  {
    nix-homebrew = {
      enable = true;
      # also install Homebrew under the default Intel prefix for Rosetta 2 (if Rosetta installed)
      enableRosetta = false;
      # with mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
      # mutableTaps = false;
      taps = {
        "homebrew/homebrew-bundle" = homebrew-bundle;
        "homebrew/homebrew-core" = homebrew-core;
        "homebrew/homebrew-cask" = homebrew-cask;
      };
      user = "joaquin";
    };
  }
]
