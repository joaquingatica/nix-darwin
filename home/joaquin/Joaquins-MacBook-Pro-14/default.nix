{ config, ... }: {
  imports = [
    ../common/presets/nix-darwin.nix
  ];

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "gradle/gradle.properties" = {
        path = "${config.xdg.configHome}/gradle/gradle.properties";
      };
      "npm/npmrc" = {
        path = "${config.xdg.configHome}/npm/.npmrc";
      };
    };
  };
}
