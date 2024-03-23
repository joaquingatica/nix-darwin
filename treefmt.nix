{ pkgs, ... }: {
  # used to find the project root
  projectRootFile = "flake.nix";
  programs = {
    # *.nix files
    alejandra.enable = true;
    # *.{json,md,yaml} files
    prettier.enable = true;
  };
}
