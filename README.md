# Joaquin's `nix-darwin` Configuration

## TODOs

- [ ] Add `home-manager`
- [ ] Enable Flake support through `home-manager` instead of dependencies
- [ ] Add `direnv` through this configuration instead of dependencies
- [ ] Add `cachix` through this configuration instead of dependencies
- [ ] Add other programs that were installed through homebrew

## Setup Environment

### 1. Setup `nix`

1. Run `curl -L https://nixos.org/nix/install | sh` to install Nix.
2. In a new terminal, verify installation with `nix --version`
3. Enable flake support:
```shell
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Documentation: https://nix.dev/install-nix

### 2. Setup `nix-darwin`

Run `nix run nix-darwin -- switch --flake .`

### 3. Setup `cachix`

Install `cachix` flake profile to speed up installations:

```shell
nix profile install nixpkgs#cachix
```

Add current user as trusted for `nix` binaries, and setup `cachix` for `devenv`:

```shell
echo "trusted-users = root $USER" | sudo tee -a /etc/nix/nix.conf && sudo pkill nix-daemon
cachix use devenv
```

### 4. Setup `direnv`

1. Install `direnv`: `brew install direnv`
2. Add the shell how with the following line at the end of `~/.zshrc`:
```shell
eval "$(direnv hook zsh)"
```

### 5. Setup repository

1. Clone this repository in the user folder `~/`
2. In `~/nix-darwin`, run `nix profile install .` (make sure to only run it once)
3. To set up the remote Linux builder, follow the instructions below in [Setup Remote Linux Builder for macOS](#setup-remote-linux-builder-for-macos)

## Useful Commands

* Check available Nix profiles: `nix profile list`
* Upgrade Nix profile: `nix profile upgrade 3` (replace `3` with the profile number)
* Apply changes to `nix-darwin` configuration: `darwin-rebuild switch --flake .`

## Resources

- `nix-darwin` manual: https://daiderd.com/nix-darwin/manual/
- Remote Linux builder for macOS: https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder
