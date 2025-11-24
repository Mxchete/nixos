{
  description = "NixOS Top Level flake.nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    # nix-software-center.url = "github:snowfallorg/nix-software-center";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    # Temp until updated by lzbt
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland"; # to make sure that the plugin is built for the correct version of hyprland
    };
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    hy3 = {
      url = "github:outfoxxed/hy3"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
      inputs.hyprland.follows = "hyprland";
    };
    # ax-shell = {
    #   url = "github:poogas/Ax-Shell";
    #   inputs.nixpkgs.follows = "nixpkgs";
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
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # dms-cli = {
    #   url = "github:AvengeMedia/danklinux";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # dankMaterialShell = {
    #   url = "github:AvengeMedia/DankMaterialShell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.dgop.follows = "dgop";
    #   inputs.dms-cli.follows = "dms-cli";
    # };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self
    , nixpkgs
    , chaotic
    , lanzaboote
    , home-manager
    , nix-colors
    , nur
    , hy3
    # , ax-shell
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
            ./modules/noctalia.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; }; # from the passed down input, we can pass these as args to `home.nix`
              home-manager.users.mxchete = import ./home;
            }
            ./modules/auto-upgrade.nix
          ];
        };
      };
    };
}
