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

### 4. Post installation

#### 4.1. Ensure `~/.gnupg` permissions

Run `gpg --list-secret-keys --keyid-format=long` and verify that no `unsafe permissions on homedir`
warning is printed. If a warning is printed, run the following commands to fix the permissions:

```shell
find ~/.gnupg -type f -exec chmod 600 {} \; # Set 600 for files
find ~/.gnupg -type d -exec chmod 700 {} \; # Set 700 for directories
``` 

#### 4.2. Restart GPG agent

Run `gpgconf --kill gpg-agent` to restart the GPG agent and apply the new configurations.

#### 4.3. Setup commit signing

Follow the steps in [this guide](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification)
to set up commit signing and signature verification in Git and GitHub.

## Usage

To apply changes to `nix-darwin` configuration run: `make switch`

See [`Makefile`](./Makefile) for other commands.

## Resources

- `nix-darwin` manual: https://daiderd.com/nix-darwin/manual/
- Remote Linux builder for macOS: https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder

## TODOs

- [ ] Add pre-commit formatter for this repository
- [ ] Maintain `~/.aws/config` from this repository
