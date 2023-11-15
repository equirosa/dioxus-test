{
  description = "Test quickstart repo for dioxus";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        optisize = pkgs.callPackage ./nix/optisize.nix { };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            bacon
            cargo-msrv
            openssl
            pkg-config
            rust-bin.beta.latest.default
          ];

          shellHook = '' '';
        };
        packages.default = optisize;
      }
    );
}

