{ inputs, pkgs, ... }:
{
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    ags
    wofi
    jq
    ibm-plex
    material-symbols
    nerd-fonts.jetbrains-mono
    fd
    fish
    fuzzel
    uwsm
    (python313.withPackages (python-pkgs: with python-pkgs; [
      aubio
      pyaudio
      numpy
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
}
