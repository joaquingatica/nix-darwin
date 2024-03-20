{...}: {
  programs = {
    gh = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Joaquin Gatica";
      userEmail = "joaquingatica@gmail.com";

      # TODO: enable GPG signing
      # signing = {
      #   key = "<key-here>";
      #   signByDefault = true;
      # };

      extraConfig = {
        color = {
          ui = true;
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
