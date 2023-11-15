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
            dioxus-cli
            openssl
            pkg-config
            (rust-bin.stable.latest.default.override {
              targets = [ "wasm32-unknown-unknown" ];
            })
            wasm-bindgen-cli
          ];

          shellHook = '' '';
        };
        packages.default = optisize;
      }
    );
}

