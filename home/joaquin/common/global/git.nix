{...}: {
  programs = {
    gh = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Joaquin Gatica";
      userEmail = "joaquingatica@gmail.com";

      signing = {
        key = null; # let GnuPG decide what signing key to use depending on commit’s author
        signByDefault = true;
      };

      extraConfig = {
        color = {
          ui = true;
        };

        diff = {
          external = "difft";
        };

        github = {
          user = "joaquingatica";
        };

        init = {
          defaultBranch = "main";
        };

        merge = {
          # Include common parent when merge conflicts arise
          conflictStyle = "diff3";
        };

        pull = {
          ff = "only";
        };
      };
    };
  };
}
