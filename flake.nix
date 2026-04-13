{
  description = "Linehash Edit (le): Fast, deterministic line editing CLI for LLMs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    linehash-edit-src = {
      url = "github:RogerNavelsaker/linehash-edit";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, linehash-edit-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "linehash-edit";
          version = "0.1.0";
          src = linehash-edit-src;
          cargoLock = {
            lockFile = "${linehash-edit-src}/Cargo.lock";
            allowBuiltinFetchGit = true;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ cargo rustc rustfmt clippy ];
        };
      }
    );
}
