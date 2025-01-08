# rust-devShells
Simple nix flake to provide generic rust development shells via the `nix develop` command. Designed to be used when reproducibility or unique build environments isn't necessary.

> [!TIP]
> I make these dev shells globally accessible by adding them to the flake registry via home-manager

> [!IMPORTANT]
> This method only supports flakes.

## Setup
add this repository as an input in your flake and pass it to a configuration via `extraSpecialArgs`.
```nix
## flake.nix
{
  inputs = {
    rust-devShells = {
      url = "github:AbrasiveAlmond/rust-devShells";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    # NixOS configuration example
    nixosConfigurations = {
      minifridge = nixpkgs.lib.nixosSystem {
        specialArgs = {
          # Where the magic happens
          inherit inputs;
        };

        modules = [
          # Your nixos configuration file
          ./hosts/minifridge/configuration.nix
        ];
    };

    # Home Manager configuration example
    homeConfigurations = {
      "quinnieboi@minifridge" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit inputs;
        };

        modules = [
          ./hosts/minifridge/home.nix
        ];
      };
    };
  }
...
```

Configuration is identical for both home-manager and configuration.
To make the command work globally, that is from any directory, you can add the command to your machine's flake registry via the following:

```nix
{inputs, ...}:
{
  # --snip--
  nix.registry = {
    rust.flake = inputs.rust-devShells;
  };
}
```

## Usage
After switching configurations you should have access to the devshell from anywhere via the following command:

`> nix develop rust#stable`
> [!TIP]
> note the "rust" name can be changed to anything you like.

> [!NOTE]
> If this command fails you can use `nix registry list` to see if the flake appears in your registry or check out [my nix config](https://github.com/AbrasiveAlmond/nix-config).
