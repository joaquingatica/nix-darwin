# install nix-darwin
install:
	nix run nix-darwin -- switch --flake .

# rebuild/apply changes to darwin configuration
switch:
	darwin-rebuild switch --flake .

# manually run linux builder
run-builder:
	nix run nixpkgs#darwin.linux-builder
