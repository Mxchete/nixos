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
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, chaotic, lanzaboote, home-manager, nur, ... }@inputs: {
    nixosConfigurations = {
      tengoku = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs; # this passes down the inputs
        };
        modules = [
          # ./modules/specialisation.nix
          ./configuration.nix
          chaotic.nixosModules.default
          nur.modules.nixos.default
          lanzaboote.nixosModules.lanzaboote
          ./modules/lanza.nix
          ./modules/gnome.nix
          ./modules/signon/signond.nix
          ./modules/sddm.nix
          ./modules/kde.nix
          ./modules/hyprland.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mxchete = import ./home;
            home-manager.extraSpecialArgs = inputs; # from the passed down input, we can pass these as args to `home.nix`
          }
          ./modules/auto-upgrade.nix
        ];
      };
    };
  };
}
