{
  config,
  pkgs,
  ...
}: let
  zshInitExtra = ''
    # TODO: add zsh completions and initializations
  '';

  zshProfileExtra = ''
    # TODO: add zsh profile
  '';
in {
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      historyControl = ["ignoredups" "ignorespace"];
    };
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      dotDir = builtins.replaceStrings ["${config.home.homeDirectory}"] [""] "${config.xdg.configHome}/zsh";
      history = {
        path = "${config.xdg.dataHome}/zsh/zsh_history";
        expireDuplicatesFirst = true;
        extended = true;
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
        save = 100000;
        size = 100000;
      };
       oh-my-zsh = {
         enable = true;
         plugins = [
           "aws"
           "docker"
           "docker-compose"
           "git"
           "terraform"
         ];
         theme = "clean";
       };
      syntaxHighlighting.enable = true;
      initExtra = zshInitExtra;
      profileExtra = zshProfileExtra;
    };
  };
}
