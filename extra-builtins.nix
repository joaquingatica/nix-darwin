{exec, ...}: {
  # Decrypt a file using sops and return the result as a string
  decrypt = file:
    exec [
      "bash"
      "-c"
      ''
        set -euo pipefail
        f=$(mktemp)
        trap "rm $f" EXIT
        set -x
        sops -d "${file}" > $f
        nix-instantiate --eval --expr "builtins.readFile $f"
      ''
    ];
}
