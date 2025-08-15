{ inputs, lib, pkgs, ... }:
{
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://ghostty.cachix.org"
    ];
    trusted-substituters = [
      "https://hyprland.cachix.org"
      "https://ghostty.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
    ];
  };
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
      niri = {
        prettyName = "Niri";
        comment = "Niri compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/niri-session";
      };

    };
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    hyprnome
    hyprcursor
    hyprutils
    hyprlang
    hyprpolkitagent
    hyprlock
    hypridle
    hyprland-qtutils
    hyprland-qt-support
    hyprsysteminfo
    ags
    wofi
    jq
    ibm-plex
    material-symbols
    material-icons
    nerd-fonts.jetbrains-mono
    fd
    fish
    fuzzel
    uwsm
    (python313.withPackages (python-pkgs: with python-pkgs; [
      aubio
      pyaudio
      numpy
      websockets
    ]))
    # python313Packages.aubio
    # python313Packages.pyaudio
    # python313Packages.numpy
    cava
    bluez-tools
    # ddcutil
    brightnessctl
    imagemagick
    linux-wallpaperengine
    nwg-look
  ];

  # Here until it warrants its own file
  services.displayManager.ly = {
    enable = false;
    settings = {
      animate = true;
      animation = "matrix";
      bigclock = "en";
      bigclock_12hr = false;
      bigclock_seconds = true;
      clear_password = true;
      tty = lib.mkForce 7;
    };
  };
}
