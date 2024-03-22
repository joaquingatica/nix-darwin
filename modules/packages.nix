{ nixpkgs, nixpkgs-unstable, ... }: [
  {
    nixpkgs.config.allowUnfree = true; # for terraform
    nixpkgs.overlays = [
      (prev: final: {
        unstable = import nixpkgs-unstable { inherit (prev) system; };
      })
    ];
  }
]
