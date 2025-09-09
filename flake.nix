{
  description = "NixOS Flake with Disko, Btrfs, KDE Plasma, and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
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
        # ✅ NixOS configuration
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

        # ✅ Top-level apps output
        apps = {
          disko-install = {
            type = "app";
            program = "${disko.packages.${system}.disko-install}/bin/disko-install";
          };

          default = {
            type = "app";
            program = "${disko.packages.${system}.disko-install}/bin/disko-install";
          };
        };

        # ✅ Top-level packages output
        packages = {
          disko-install = disko.packages.${system}.disko-install;
          default = disko.packages.${system}.disko-install;
        };
      });
}
