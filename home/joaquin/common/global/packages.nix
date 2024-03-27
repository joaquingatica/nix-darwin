{pkgs, ...}: {
  home.packages = with pkgs; [
    awscli2
    docker
    docker-compose
    gnupg
    nodejs
    nodePackages.gulp-cli
    pre-commit
    terraform
    yarn
    yq
  ];
}
