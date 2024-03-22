{ config, ... }: {
  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets = {
      "awscli/config" = {
        sopsFile = ./secrets/awscli.yaml;
        key = "config";
        path = "${config.xdg.configHome}/aws/config";
      };
      "gradle/gradle.properties" = {
        path = "${config.xdg.configHome}/gradle/gradle.properties";
      };
      "npm/npmrc" = {
        path = "${config.xdg.configHome}/npm/.npmrc";
      };
    };
  };
}
