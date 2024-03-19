{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nix-darwin = {
        url = "github:lnl7/nix-darwin/master";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs
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
      "Joaquins-MacBook-Pro" = darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./hosts/Joaquins-MacBook-Pro/default.nix
        ];
      };
      "Joaquins-MacBook-Pro-14" = darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/Joaquins-MacBook-Pro-14/default.nix
        ];
      };
    };
  };
}
