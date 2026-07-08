# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

let
  # The following is a workaround for the NVIDIA VRAM leak on Wayland.
  # Hyprland was using >3GB of VRAM after a day of use
  # See: https://github.com/NVIDIA/egl-wayland/issues/126#issuecomment-2379945259
  limitFreeBufferProfile = builtins.toJSON {
    rules = [
      # See https://github.com/hyprwm/Hyprland/issues/7704#issuecomment-2639212608
      # for tip about using `.Hyprland-wrapped` instead of `hyprland`.
      {
        pattern = { feature = "procname"; matches = ".Hyprland-wrapped"; };
        profile = "Limit Free Buffer Pool On Wayland Compositors";
      }
      {
        pattern = { feature = "procname"; matches = "gnome-shell"; };
        profile = "Limit Free Buffer Pool On Wayland Compositors";
      }
      {
        pattern = { feature = "procname"; matches = "kwin_wayland"; };
        profile = "Limit Free Buffer Pool On Wayland Compositors";
      }
      {
        pattern = { feature = "procname"; matches = ".kwin_wayland-wrapped"; };
        profile = "Limit Free Buffer Pool On Wayland Compositors";
      }
      {
        pattern = { feature = "procname"; matches = ".plasmashell-wrapped"; };
        profile = "Limit Free Buffer Pool On Wayland Compositors";
      }
      {
        pattern = { feature = "procname"; matches = "linux-wallpaperengine"; };
        profile = "Limit Free Buffer Pool On Wayland Compositors";
      }
      {
        pattern = { feature = "procname"; matches = ".mpvpaper-wrapped"; };
        profile = "Limit Free Buffer Pool On Wayland Compositors";
      }
    ];
    profiles = [
      {
        name = "Limit Free Buffer Pool On Wayland Compositors";
        settings = [{ key = "GLVidHeapReuseRatio"; value = 0; }];
      }
    ];
  };
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Desktop Environment Selection
      # System Modules
      ./modules/fonts.nix
    ];

  nixpkgs.overlays = [
    (final: prev: {
      jdk8 = final.openjdk8-bootstrap;
    })
  ];

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


  # environment.sessionVariables.ALSA_CONFIG_UCM2 =
  #   let
  #     alsa-ucm-conf = pkgs.fetchFromGitHub {
  #       owner = "alsa-project";
  #       repo = "alsa-ucm-conf";
  #       rev = "v1.2.14";
  #       sha256 = "sha256-U/gMam8veX3nrmP3X8EdWGQjC5AbcxadTelUXwIVhFA=";
  #     };
  #   in
  #   "${alsa-ucm-conf}/ucm2";

  # NVIDIA VRAM leak workaround, see comment at top.
  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text =
    limitFreeBufferProfile;

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita";
        color-scheme = "prefer-dark";
      };
    }
  ];

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

  programs.obs-studio = {
    enable = true;

    # optional Nvidia hardware acceleration
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi #optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
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
    extraGroups = [ "wheel" "networkmanager" "audio" "dialout" "docker" ];
  };

  security.sudo.wheelNeedsPassword = false;

  # programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  nix.settings.auto-optimise-store = true;

  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.libvirtd.enable = true;
  # users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    # docker.enable = true;
  };
  virtualisation.waydroid.enable = true; # Broken, python version issue
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

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
      proton-ge-bin
      # protonup-qt
      # proton-cachyos_x86_64_v4
    ];
  };
  programs.gamemode.enable = true;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  environment.variables = {
    NIX_NEOVIM = "1";
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # Packages
    inputs.quickshell.packages.${stdenv.hostPlatform.system}.default
    adw-gtk3
    ani-cli
    arrpc
    better-control
    bibata-cursors
    # bitwarden-desktop
    btop
    cargo
    celluloid
    cozette
    dconf
    (discord.override {
      withVencord = true;
    })
    distrobox
    (callPackage ./packages/drv { })
    fastfetch
    ffmpeg
    firefox
    # flatpak
    fzf
    gcc
    gdm-settings
    geekbench
    ghostty
    git
    gnome-boxes
    gnome-software
    gnome-tweaks
    google-chrome
    goverlay
    heroic
    htop
    ifuse
    jp2a
    kando
    kdePackages.isoimagewriter
    kdePackages.ocean-sound-theme
    kitty
    lact
    libimobiledevice
    libnotify
    libreoffice
    limo # TODO: 9/19 fails to build dep rn 
    localsend
    # lutris
    # minecraft # Currently Broken ???
    mangohud
    morewaita-icon-theme
    mpv
    neovim
    # nexusmods-app-unfree
    # oneko
    # openloco
    # openrct2
    # openrgb-with-all-plugins
    oreo-cursors-plus
    p7zip
    pavucontrol
    pay-respects
    pciutils
    podman-compose
    podman-tui
    poppler
    poppler-utils
    prismlauncher
    protonup-qt
    python313
    qemu
    r2modman
    resources
    ripgrep
    sbctl
    smartmontools
    sshfs
    stow
    timeshift
    tmux
    tree
    usbutils
    vim-full
    vlc
    vscode
    vscode.fhs
    wget
    # winboat
    wirelesstools
    wl-clipboard
    yt-dlp
    xeyes
    zoom-us
  ];


  # Services
  services.orca.enable = lib.mkForce false;
  services.xserver.enable = true;
  services.flatpak.enable = true;
  # TODO: Remove package override when merged in
  services.flatpak.package = (
    pkgs.flatpak.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [
        (pkgs.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/flatpak/flatpak/pull/6721.patch";
          sha256 = "sha256-g2tQ++3XMK7oBxcPGhtAcsHE1WEj9OgyS0QRmqv1b8I=";
        })
      ];
    })
  );
  # services.hardware.openrgb.enable = true;
  services.usbmuxd.enable = true;
  services.fwupd.enable = true;
  services.journald.extraConfig = "MaxFileSec=1month";
  services.lact.enable = true;
  services.apcupsd = {
    enable = true;
  };
  services.snapper = {
    snapshotInterval = "hourly"; # used with `OnCalendar`, so must be interval
    cleanupInterval = "3h"; # used with `OnUnitActiveSec`, so must be duration

    /*
      I have all relevant mutable stuff consolidated on the persist subvolume, everything else is
      (hopefully) reproducibly in the Nix store or ephemeral. Of that mutable state I create a
      snapshot timeline so I can revert accidents and look at previous states.

      See: http://snapper.io/manpages/snapper-configs.html
    */
    configs.home = {
      /*
        snapper assumes that there is a nested subvolume at `.snapshots` in the subvolume to be
        snapshotted, so in this case at `/home/.snapshots`.
      */
      SUBVOLUME = "/home";
      FSTYPE = "btrfs";
      ALLOW_USERS = [ ]; # I want only root, which is implicit

      /*
        When there's a snapper config, NixOS enables a systemd timer unit that regularly calls snapper to create
        a timeline snapshot or run a cleanup, following the intervals from above.
      */
      TIMELINE_CREATE = true; # create timeline snapshots for this config
      TIMELINE_CLEANUP = true; # run timeline snapshot cleanup for this config

      /*
        The amount of snapshots to keep per interval.

        For any given hour, day and so on the first snapshot is kept. That is done for the last n
        hours, days and so on, as configured. All other snapshots will be pruned when the cleanup
        runs. Weeks start on Monday.

        So e.g. if 2 daily snapshots were configured, the first snapshot from today and yesterday
        would be kept.
      */
      TIMELINE_LIMIT_HOURLY = "12";
      TIMELINE_LIMIT_DAILY = "7";
      TIMELINE_LIMIT_WEEKLY = "0";
      TIMELINE_LIMIT_MONTHLY = "0";
      TIMELINE_LIMIT_YEARLY = "0";
    };
  };
  # services.smartd.enable = true;

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
  # Enable this for testing ESP32
  # networking.firewall.allowedTCPPorts = [ 3000 ];
  # networking.firewall.allowedTCPPorts = [ 4000 ];
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

