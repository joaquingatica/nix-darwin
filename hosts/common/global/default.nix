{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./environment.nix
    ./nix.nix
    ./packages.nix
    ./shells.nix
  ];
}
