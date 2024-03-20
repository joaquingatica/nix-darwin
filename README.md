# Joaquin's `nix-darwin` Configuration

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

### 2. Create `~/.gnupg` folder

If `~/.gnupg` folder doesn't exist, create it: `mkdir ~/.gnupg`.

This is to work around  a minor `gnupg` agent [issue that prints warnings if folder doesn't exist]( https://github.com/NixOS/nixpkgs/issues/29331#issuecomment-685282396).

### 3. Setup repository & `nix-darwin`

1. Clone this repository in the folder: `~/.config`
2. In `~/.config/nix-darwin`, run `make install`

## Usage

To apply changes to `nix-darwin` configuration run: `make switch`

See [`Makefile`](./Makefile) for other commands.

## Resources

- `nix-darwin` manual: https://daiderd.com/nix-darwin/manual/
- Remote Linux builder for macOS: https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder

## TODOs

- [ ] Add pre-commit formatter for this repository
