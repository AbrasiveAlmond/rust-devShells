# in flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # flake-utils.follows = "flake-utils"; nonexistent input error?
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem
    (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        # 👇 new! note that it refers to the path ./rust-toolchain.toml
        # WHAT ARE YOU RUSTTOOLCHAIN??? I assume you keep track/set cargo and rustc versions
        # but I literally cannot generate and use you in a way I want.
        # rustToolchain = pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      in
      with pkgs;
      {
        devShells.rust-stable = mkShell {
          buildInputs = [ rust-bin.stable.latest.default ];

          shellHook = ''
            echo "entering awesome rust dev environment"
            # echo `${cargo}/bin/cargo --version`
            exec nu
          '';
        };
      }
    );
}
