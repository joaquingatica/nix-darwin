{pkgs, ...}: {
  home.packages = with pkgs; [
    awscli2
    docker
    docker-compose
    gnupg
    grpcurl
    nodejs
    nodePackages.gulp-cli
    pre-commit
    terraform
    yarn
    yq
  ];
}
