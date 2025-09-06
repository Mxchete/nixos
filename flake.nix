{
  description = "NixOS Top Level flake.nix";
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
    # hyprland = {
    #   type = "git";
    #   url = "https://github.com/hyprwm/Hyprland";
    #   submodules = true;
    # };
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # hypr-dynamic-cursors = {
    #   url = "github:VirtCode/hypr-dynamic-cursors";
    #   inputs.hyprland.follows = "hyprland"; # to make sure that the plugin is built for the correct version of hyprland
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
    # ghostty = {
    #   url = "github:ghostty-org/ghostty";
    # };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # mikuboot = {
    #   url = "gitlab:evysgarden/mikuboot";
    #   inputs.nixpkgs.follows = ""; # only useful for the package output
    # };
    # niri = {
    #   url = "github:sodiboo/niri-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nix-colors.url = "github:misterio77/nix-colors";
  };
  outputs =
    { self
    , nixpkgs
    , chaotic
    , lanzaboote
    , home-manager
    , nix-colors
    , nur
      # , ghostty
    # , mikuboot
      # , hyprland
      # , niri
    , ...
    }@inputs: {
      nixosConfigurations = {
        tengoku = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs; # this passes down the inputs
          };
          modules = [
            # ./modules/specialisation.nix
            ./configuration.nix
            ({ pkgs, ... }: {
              environment.systemPackages = [
                # ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
              ];
            })
            # mikuboot.nixosModules.default
            chaotic.nixosModules.default
            nur.modules.nixos.default
            lanzaboote.nixosModules.lanzaboote
            ./modules/lanza.nix
            ./modules/gnome.nix
            ./modules/sddm.nix
            ./modules/kde.nix
            ./modules/hyprland.nix
            ./modules/niri.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; }; # from the passed down input, we can pass these as args to `home.nix`
              home-manager.users.mxchete = import ./home;
            }
            # ./home
            ./modules/auto-upgrade.nix
          ];
        };
      };
    };
}
