{
  description = "Home Manager configuration of remote";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, sops-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [inputs.home-manager.flakeModules.home-manager ];
      systems = [ "x86_64-linux" ];
      flake.homeConfigurations."remote" =
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
          modules = [ ./home.nix sops-nix.homeManagerModules.sops ];
        };
    };
}
