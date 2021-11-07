{ pkgs ? import ./pkgs.nix {}
, opam2nix ? import ./opam2nix.nix {}
}:
let
  ocaml = pkgs.ocaml;
  selection = opam2nix.build {
    inherit ocaml;
    selection = ./opam-selection.nix;
    src = ../.;
  };
in selection.pycoq
