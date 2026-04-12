{
  description = "Fast hashmap line editing CLI for LLMs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    llm-hash-edit-src = {
      url = "github:RogerNavelsaker/llm-hash-edit-cli";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, llm-hash-edit-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "llm-hash-edit";
          version = "0.1.0";
          src = llm-hash-edit-src;
          cargoLock = {
            lockFile = "${llm-hash-edit-src}/Cargo.lock";
            allowBuiltinFetchGit = true;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ cargo rustc rustfmt clippy ];
        };
      }
    );
}
