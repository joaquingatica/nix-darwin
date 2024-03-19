{pkgs, ...}: {
  services.nix-daemon.enable = true;

  nix = {
    settings.trusted-users = [ "root" "joaquin" ];

    linux-builder = {
      enable = false;
      maxJobs = 4;
      config = {
        virtualisation.cores = 4;
      };
    };
  };
}
