{
  config,
  lib,
  ...
}: {
  imports = [
    ./git.nix
    ./packages.nix
    ./shells.nix
    ./sops.nix
  ];

  home = {
    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    sessionVariables = {
      GRADLE_USER_HOME = "${config.xdg.configHome}/gradle";
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/.npmrc";
    };

    stateVersion = lib.mkDefault "23.11";

    username = lib.mkDefault "joaquin";
  };

  programs = {
    home-manager = {
      enable = true;
    };
  };

  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    cacheHome = "${config.home.homeDirectory}/.cache";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };
}
