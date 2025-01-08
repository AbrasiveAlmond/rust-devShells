# rust-dev-flake
Simple flake to provide generic rust development shells via the `nix develop` command.

> [!IMPORTANT]
> This method only supports flakes.

## Setup
add this repository as an input in your flake
```
## flake.nix
inputs = {
  rust-devShells = {
    url = "github:AbrasiveAlmond/rust-dev-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
...
```

## Usage
Configuration is identical for both home-manager and configuration.
To make the command work globally, that is from any directory, you can add the command to your machine's flake registry via the following:

```
{inputs, ...}:
{
  # snip

  nix.registry = {
    rust.flake = inputs.rust-devShells;
  };
}
```
After a switch you should have access to the devshell from anywhere via the following command:
`> nix develop rust#stable`
note the "rust" name can be changed to anything you like
