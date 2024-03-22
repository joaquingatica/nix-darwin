# install nix-darwin
install:
	nix run nix-darwin -- switch --flake .

# rebuild/apply changes to darwin configuration
switch:
	darwin-rebuild switch --option extra-builtins-file $$PWD/extra-builtins.nix --flake .

# manually run linux builder
run-builder:
	nix run nixpkgs#darwin.linux-builder

sops-nix-env-vars:
	sops hosts/Joaquins-MacBook-Pro-14/secrets/nix-env-vars.json

sops-secrets:
	sops home/joaquin/common/global/secrets/secrets.yaml

sops-awscli:
	sops home/joaquin/common/global/secrets/awscli.yaml
