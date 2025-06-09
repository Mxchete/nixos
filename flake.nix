{
  description = "minimal starter flake.nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # nix-software-center.url = "github:snowfallorg/nix-software-center";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "git+https://github.com/Aylur/ags?rev=60180a184cfb32b61a1d871c058b31a3b9b0743d";
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
  };
  outputs = { self, nixpkgs, chaotic, lanzaboote, home-manager, ... }@inputs: {
    nixosConfigurations = {
      tengoku = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs; # this passes down the inputs
        };
        modules = [
          ./configuration.nix
          chaotic.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          ./modules/lanza.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mxchete = import ./home;
            home-manager.extraSpecialArgs = inputs; # from the passed down input, we can pass these as args to `home.nix`
          }
        ];
      };
    };
  };
}
