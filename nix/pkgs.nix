{ tag ? import ./tag.nix }:
import (builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/${tag}.tar.gz";
}) {}
