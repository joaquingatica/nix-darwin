# Joaquin's `nix-darwin` Configuration

## TODOs

- [ ] Add `home-manager`
- [ ] Enable Flake support through `home-manager` instead of dependencies
- [ ] Add `direnv` through this configuration instead of dependencies
- [ ] Add `cachix` through this configuration instead of dependencies
- [ ] Add other programs that were installed through homebrew
- [ ] Add formatter for nix

## Setup Environment

### 0. Update configuration for new system

1. Create appropriate folder in `./hosts` with the base configuration
2. Update `darwinConfigurations` in `flake.nix` to use the new configuration

### 1. Setup `nix`

1. Run `curl -L https://nixos.org/nix/install | sh` to install Nix.
2. In a new terminal, verify installation with `nix --version`
3. Enable flake support:
```shell
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Documentation: https://nix.dev/install-nix

### 2. Setup `cachix`

Install `cachix` flake profile to speed up installations:

```shell
nix profile install nixpkgs#cachix
```

### 3. Setup repository & `nix-darwin`

1. Clone this repository in the folder: `~/.config`
2. In `~/.config/nix-darwin`, run `make install`

## Useful Commands

* Apply changes to `nix-darwin` configuration: `make switch`
* Manually run linux builder: `make run-builder`

## Resources

- `nix-darwin` manual: https://daiderd.com/nix-darwin/manual/
- Remote Linux builder for macOS: https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder
