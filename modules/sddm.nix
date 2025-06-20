{ config, lib, pkgs, ... }:

let
  background-package = pkgs.stdenvNoCC.mkDerivation {
    name = "background-image";
    src = ./wallpaper.png;
    dontUnpack = true;
    installPhase = ''
      cp $src $out
    '';
  };
  sddmVT1 = pkgs.kdePackages.sddm.overrideDerivation (prev: {
    cmakeFlags = (prev.cmakeFlags) ++ [
      "-DSDDM_INITIAL_VT=1"
    ];
  });

in
{
  services.xserver.enable = true;
  services.displayManager.sddm = {
    package = lib.mkForce sddmVT1;
    enable = lib.mkDefault true;
    enableHidpi = true;
    theme = "breeze";
    wayland.enable = true;
    wayland.compositor = "kwin";
  };
  environment.systemPackages = with pkgs; [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background = "${background-package}"
    '')
  ];

}
