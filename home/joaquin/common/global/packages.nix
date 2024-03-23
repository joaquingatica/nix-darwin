{pkgs, ...}: {
  home.packages = with pkgs; [
    awscli2
    docker
    docker-compose
    gnupg
    nodejs
    pre-commit
    terraform
    yarn
    yq
  ];
}
