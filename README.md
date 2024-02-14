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

### 2. Setup `cachix`

Install `cachix` flake profile to speed up installations:

```shell
nix profile install nixpkgs#cachix
```

Add current user as trusted for `nix` binaries, and setup `cachix` for `devenv`:

```shell
echo "trusted-users = root $USER" | sudo tee -a /etc/nix/nix.conf && sudo pkill nix-daemon
cachix use devenv
```

### 3. Setup `direnv`

1. Install `direnv`: `brew install direnv`
2. Add the shell how with the following line at the end of `~/.zshrc`:
```shell
eval "$(direnv hook zsh)"
```

### 4. Setup repository

1. Clone this repository in the user folder `~/`
2. In `~/nix-darwin`, run `nix profile install .` (make sure to only run it once)
3. To set up the remote Linux builder, follow the instructions below in [Setup Remote Linux Builder for macOS](#setup-remote-linux-builder-for-macos)

## Useful Commands

* Check available Nix profiles: `nix profile list`
* Upgrade Nix profile: `nix profile upgrade 0` (replace `0` with the profile number)

## Resources

- `nix-darwin` manual: https://daiderd.com/nix-darwin/manual/
- Remote Linux builder for macOS: https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder

## Setup Remote Linux Builder for macOS

As per [`devenv.sh` Containers documentation](https://devenv.sh/containers/), a remote Linux builder
is needed to generate the containers in macOS.

1. Update `/etc/nix/nix.conf` to set the user as trusted and to delegate builds to the remote
   builder (note the comments with the placeholders to replace):

```shell
# - Replace ${USERNAME} with your computer's username
extra-trusted-users = ${USERNAME}

# - Replace ${ARCH} with either aarch64 or x86_64 to match your host machine
# - Replace ${MAX_JOBS} with the maximum number of builds (pick 4 if you're not sure)
builders = ssh-ng://builder@linux-builder ${ARCH}-linux /etc/nix/builder_ed25519 ${MAX_JOBS} - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=

# Not strictly necessary, but this will reduce your disk utilization
builders-use-substitutes = true
```

2. Allow Nix to connect to the remote builder, given that the port is different from 22, by running:

```shell
sudo sh -c "cat >> /etc/ssh/ssh_config.d/100-linux-builder.conf" << EOF
Host linux-builder
  Hostname localhost
  HostKeyAlias linux-builder
  Port 31022
EOF
```

3. Restart Nix daemon to apply the change: `sudo launchctl kickstart -k system/org.nixos.nix-daemon`

4. Run the linux builder with `nix run nixpkgs#darwin.linux-builder`

5. To shut down the builder, run `shutdown now` inside it

For additional information, see [the complete documentation](https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder).
