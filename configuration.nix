# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Desktop Environment Selection
      ./gnome.nix
      ./hyprland.nix
      # System Modules
      ./modules/fonts.nix
    ];

  # nixpkgs.overlays = [
  #   ( import ./overlays/alsa-ucm-conf.nix )
  # ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tengoku"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.networkmanager.wifi.backend = "iwd";

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  environment.sessionVariables.ALSA_CONFIG_UCM2 =
    let
      # Updated version with https://github.com/alsa-project/alsa-ucm-conf/issues/123 bugfix.
      alsa-ucm-conf = pkgs.fetchFromGitHub {
        owner = "alsa-project";
        repo = "alsa-ucm-conf";
        rev = "v1.2.14";
        sha256 = "sha256-U/gMam8veX3nrmP3X8EdWGQjC5AbcxadTelUXwIVhFA="; # Replace this
      };
    in
    "${alsa-ucm-conf}/ucm2";


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    # openfirewall = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # Shell
  programs.zsh = {
    enable = true;
    # oh-my-zsh = { # "ohMyZsh" without Home Manager
    #   enable = true;
    #   plugins = [ "git" "zsh-autosuggestions" "zsh-vi-mode" "zsh-autocomplete" "zsh-syntax-highlighting" ];
    # };
  };
  users.defaultUserShell = pkgs.zsh;

  users.users.mxchete = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" ];
  };

  security.sudo.wheelNeedsPassword = false;

  # programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      # "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "daily";
  };

  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # enableNvidia = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  virtualisation.waydroid.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      steamtinkerlaunch
    ];
  };
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # Special GUI software center package
    # inputs.nix-software-center.packages.${system}.nix-software-center
    # Packages
    adw-gtk3
    ani-cli
    better-control
    cargo
    celluloid
    dconf
    discord
    distrobox
    fastfetch
    firefox
    flatpak
    fzf
    gcc
    ghostty
    git
    gnome-boxes
    gnome-software
    gnome-tweaks
    google-chrome
    heroic
    kando
    kdePackages.ocean-sound-theme
    libreoffice
    limo
    # minecraft # Currently Broken ???
    morewaita-icon-theme
    neovim
    nexusmods-app-unfree
    openloco
    openrct2
    oreo-cursors-plus
    pavucontrol
    pay-respects
    pciutils
    prismlauncher
    python3
    r2modman
    resources
    sbctl
    # steam
    # steamtinkerlaunch
    stow
    usbutils
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vscode
    vscode.fhs
    wget
    wirelesstools
    wl-clipboard
  ];

  # GUI TODO: Spin into seperate files for each GUI
  services.xserver.enable = true;

  # Services
  services.flatpak.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

