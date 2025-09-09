{
  description = "NixOS Flake with Disko, Btrfs, KDE Plasma, and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    disko.url = "github:nix-community/disko";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, disko, home-manager, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        nixosConfigurations.standard = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/standard/configuration.nix
            ./hosts/standard/disko.nix
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            ./nixos/hardware-configuration.nix
          ];
          specialArgs = {
            inherit home-manager;
          };
        };
        packages.default = disko.packages.${system}.disko-install;
      });
}
