# install nix-darwin
install:
	nix run nix-darwin -- switch --flake .

# rebuild/apply changes to darwin configuration
switch:
	darwin-rebuild switch --option extra-builtins-file $$PWD/extra-builtins.nix --flake .

# manually run linux builder
run-builder:
	nix run nixpkgs#darwin.linux-builder
