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

        # Execute user's default shell, nushell as of writing
        # was really having difficulty with "exec $SHELL"
        # it keeps changing between nu and bash and not even
        # depending on which shell you're currently in
        # thanks to https://unix.stackexchange.com/a/352430
        shellHook = ''
          exec `getent passwd $USER | cut -d : -f 7`
        '';
      };

      devShells.nightly = mkShell {
        buildInputs = [ rust-bin.nightly.latest.default ];

        shellHook = ''
          exec `getent passwd $USER | cut -d : -f 7`
        '';
      };

      devShells.toolchain = mkShell {
        buildInputs = [ rustToolchain ];

        shellHook = ''
          exec `getent passwd $USER | cut -d : -f 7`
        '';
      };
    }
  );
}
