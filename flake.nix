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

      # packages = [ pkgs.rust-analyzer ];
      # There's no simple way to generate a rust-toolchain file:
      # https://github.com/rust-lang/rustup/issues/2868
      # otherwise it would be a great way to pin versions of cargo n stuff per-project
      rustToolchain = pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
    in
    with pkgs;
    {
      devShells.stable = mkShell {
        buildInputs = [ rust-bin.stable.latest.default ];

        shellHook = ''
          exec nu
        '';
      };

      devShells.nightly = mkShell {
        buildInputs = [ rust-bin.nightly.latest.default ];

        shellHook = ''
          exec nu
        '';
      };

      devShells.toolchain = mkShell {
          buildInputs = [ rustToolchain ];
      };
    }
  );
}
