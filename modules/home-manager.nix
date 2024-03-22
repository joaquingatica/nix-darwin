inputs@{ home-manager, sops-nix, ... }: [
  home-manager.darwinModules.home-manager
  {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.joaquin = import ../home/joaquin/ang-joaquin-mbp14.nix;
      extraSpecialArgs = { inherit inputs; };
      sharedModules = [
        sops-nix.homeManagerModules.sops
      ];
    };
    # https://github.com/LnL7/nix-darwin/issues/682
    users.users.joaquin.home = "/Users/joaquin";
  }
]
