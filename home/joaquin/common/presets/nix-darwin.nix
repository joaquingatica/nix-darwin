{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../global
  ];

  home = {
    homeDirectory = lib.mkDefault "/Users/${config.home.username}";

    packages = with pkgs; [
      # add packages here
    ];
  };
}
