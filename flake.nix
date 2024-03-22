{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
        url = "github:lnl7/nix-darwin/master";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs = {
        nix-darwin.follows = "nix-darwin";
        nixpkgs.follows = "nixpkgs";
      };
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nix-darwin,
    nix-homebrew,
    sops-nix
  }: let
    supportedSystems = ["x86_64-darwin" "aarch64-darwin"];
    forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
    inherit (nix-darwin.lib) darwinSystem;

    inferLinuxSystem = system: builtins.replaceStrings [ "darwin" ] [ "linux" ] system;
  in {
    packages = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages."${system}";
    in {
      default = pkgs.buildEnv {
        name = "shared-env";
        paths = with pkgs; [
          # TODO: add package dependencies here
        ];
      };
    });

    darwinConfigurations = {
      "Joaquins-MacBook-Pro-14" = darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/Joaquins-MacBook-Pro-14/default.nix
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.joaquin = import ./home/joaquin/Joaquins-MacBook-Pro-14;
              extraSpecialArgs = { inherit inputs; };
              sharedModules = [
                sops-nix.homeManagerModules.sops
              ];
            };
            nix-homebrew = {
              enable = true;
              user = "joaquin";
              # also install Homebrew under the default Intel prefix for Rosetta 2 (if Rosetta installed)
              # enableRosetta = true;
              # with mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              # mutableTaps = false;
            };
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [
              (prev: final: {
                unstable = import nixpkgs-unstable { inherit (prev) system; };
              })
            ];
            # https://github.com/LnL7/nix-darwin/issues/682
            users.users.joaquin.home = "/Users/joaquin";
          }
        ];
      };
    };
  };
}
