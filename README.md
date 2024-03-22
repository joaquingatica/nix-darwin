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

### 2. Pre installation

#### 2.1. Create `~/.gnupg` folder

If `~/.gnupg` folder doesn't exist, create it: `mkdir ~/.gnupg`.

This is to work around  a minor `gnupg` agent [issue that prints warnings if folder doesn't exist](https://github.com/NixOS/nixpkgs/issues/29331#issuecomment-685282396).

### 2.2. Setup encryption keys

1. From the password manager, create the `~/.ssh/id_ed25519` and `~/.ssh/id_ed25519.pub` files.
2. Create the AGE keys file by running `ssh-to-age -i ~/.ssh/id_ed25519 -private-key > ~/.config/sops/age/keys.txt`

If at some point the SSH keys need to be recreated, run `ssh-keygen -t ed25519 -C "<email-here>"`.
Keep in mind to **not** set a passphrase for the key in order to be used from `home-manager`.

### 3. Setup repository & `nix-darwin`

1. Clone this repository in the folder: `~/.config`
2. In `~/.config/nix-darwin`, run `make install`
3. Run `direnv allow` to allow `direnv` to load the environment
4. Run `make switch` to apply the configuration after the initial setup

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

## Secret Management

This project makes use of [Mozilla SOPS (Secrets OPerationS)](https://github.com/mozilla/sops)

The [`.sops.yaml`](./.sops.yaml) file at the root of the repository defines creation rules for
secrets to be encrypted with `sops`. Any files matching the defined creation rule paths will be
encrypted with the specified public keys.

### Updating Secrets

To update secrets, run `sops <path>` to open the secrets file in unencrypted edit mode,
and just save after updating. Helper `make` commands were added for ease of use. For example,
`make sops-secrets`.

If the file doesn't exist, it will be created. Make sure that a valid path regex exists in the
`.sops.yaml` file for the new file.

### Updating Secrets Configuration

The project uses [`sops-nix`](https://github.com/Mic92/sops-nix) for automatically decrypting
and injecting secrets into our NixOS configurations.

To update secret files after making changes to the `.sops.yaml` file, run the snippet below:

```bash
find . -regex $(yq -r '[.creation_rules[] | "./" + .path_regex] | join("\\|")' "$(pwd)/.sops.yaml") | \
xargs -i sops updatekeys -y {}
```

### Adding a Public Key

The easiest way to add new machines is by using SSH host keys. Use `age` to encrypt secrets.
To obtain an `age` public key, you can use the `ssh-to-age` tool to convert a host SSH Ed25519
key to the age format.

```bash
ssh-to-age -i ~/.ssh/id_ed25519.pub
```

Then add the `age` public key to the `.sops.yaml` file, apply it to the desired key groups,
and then re-encrypt the secret files (see [Updating Secrets Configuration](#updating-secrets-configuration)).

## Resources

- `nix-darwin` manual: https://daiderd.com/nix-darwin/manual/
- Remote Linux builder for macOS: https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder

## TODOs

- [ ] Add pre-commit formatter for this repository
- [ ] Maintain `~/.aws/config` from this repository
