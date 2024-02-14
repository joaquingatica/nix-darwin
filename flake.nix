{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    darwin = {
        url = "github:lnl7/nix-darwin/master";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    darwin,
    nixpkgs
  }: let
    supportedSystems = ["x86_64-darwin" "aarch64-darwin"];
    forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
    inherit (darwin.lib) darwinSystem;

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
      "Joaquins-MacBook-Pro" = let
        system = "x86_64-darwin";
      in darwinSystem {
        inherit system;
        modules = [
          {
            services.nix-daemon.enable = true;
            nix.settings.trusted-users = [ "root" "joaquin" ];

            # setup for remote linux build in macOS
            nix.distributedBuilds = true;
            nix.linux-builder = {
              enable = true;
              maxJobs = 4;
              config = {
                virtualisation.cores = 4;
              };
            };
          }
        ];
      };
    };
  };
}
