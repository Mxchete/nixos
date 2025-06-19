{ config, lib, pkgs, ... }:

let
  # Define the custom background package with the correct relative path
  background-package = pkgs.stdenvNoCC.mkDerivation {
    name = "background-image";
    src = ./wallpaper.png; # Place wallpaper.jpg in the same directory as this config file
    dontUnpack = true;
    installPhase = ''
      cp $src $out
    '';
  };

in
{
  # X11 and KDE Plasma configuration
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = lib.mkDefault true;
    theme = "breeze";
    wayland.enable = true;
  };
  environment.systemPackages = with pkgs; [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background = "${background-package}"
    '')
  ];

}
