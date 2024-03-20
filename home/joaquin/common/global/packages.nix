{pkgs, ...}: {
  home.packages = with pkgs;
    [
      awscli2
      docker
      docker-compose
      gnupg
    ];
}
