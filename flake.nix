{
  description = "My NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, sops-nix, ... }@inputs: {
    nixosConfigurations.alien = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/alien/configuration.nix
        ./hosts/alien/gpu.nix
        ./hosts/alien/hardware-configuration.nix
        sops-nix.nixosModules.sops
      ];
    };

    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./hosts/vm/configuration.nix
        sops-nix.nixosModules.sops
      ];
    };
  };
}
