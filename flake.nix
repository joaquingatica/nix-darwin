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

    linuxSystem = system: builtins.replaceStrings [ "darwin" ] [ "linux" ] system;
    # setup for remote linux build in macOS
    # to reconfigure the remote builder, see https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder-reconfiguring
    darwin-builder = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages."${system}";
    in nixpkgs.lib.nixosSystem {
      system = linuxSystem system;
      modules = [
        "${nixpkgs}/nixos/modules/profiles/macos-builder.nix"
        {
          virtualisation = {
            host.pkgs = pkgs;
            darwin-builder.hostPort = 31022; # should match `Port` set in `/etc/ssh/ssh_config.d/100-linux-builder.conf`
            darwin-builder.workingDirectory = "/var/lib/darwin-builder";
          };
        }
      ];
    });
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
      "anagram-mb16" = let
        system = "x86_64-darwin";
      in darwinSystem {
        inherit system;
        modules = [
          {
            # setup for remote linux build in macOS
            nix.distributedBuilds = true;
            nix.buildMachines = [{
              hostName = "ssh://builder@localhost";
              system = linuxSystem system;
              maxJobs = 4; # should match `MAX_JOBS` set in `builders` in `/etc/nix/nix.conf`
              supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
            }];
            launchd.daemons.darwin-builder = {
              command = "${darwin-builder.${system}.config.system.build.macos-builder-installer}/bin/create-builder";
              serviceConfig = {
                KeepAlive = true;
                RunAtLoad = true;
                StandardOutPath = "/var/log/darwin-builder.log";
                StandardErrorPath = "/var/log/darwin-builder.log";
              };
            };
          }
        ];
      };
    };
  };
}