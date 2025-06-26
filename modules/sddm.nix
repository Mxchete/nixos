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
  # sddmVT1 = pkgs.kdePackages.sddm.overrideDerivation (prev: {
  #   cmakeFlags = (prev.cmakeFlags) ++ [
  #     "-DSDDM_INITIAL_VT=1"
  #   ];
  # });
  #
  # systemd = {
  #   tmpfiles.packages = [ sddmVT1 ];
  #
  #   # We're not using the upstream unit, so copy these: https://github.com/sddm/sddm/blob/develop/services/sddm.service.in
  #   services.display-manager = {
  #     after = [
  #       "systemd-user-sessions.service"
  #       "getty@tty1.service"
  #       "plymouth-quit.service"
  #       "systemd-logind.service"
  #     ];
  #     conflicts = [
  #       "getty@tty1.service"
  #     ];
  #   };
  # };

in
{
  # systemd.services."getty@tty7.service".wantedBy = [ ];
  # services.getty.enable = false;
  # systemd.services."getty@tty1".enable = true;
  # systemd.units."getty@tty1.service" = {
  #   overrideStrategy = "asDropin";
  #   text = ''
  #     [Service]
  #     ExecStart=
  #     ExecStart=-/usr/bin/agetty --skip-login --nonewline --noissue --noclear %I $TERM
  #   '';
  # };
  # systemd.services."autovt@tty7".enable = true;
  services.xserver.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
  # security.pam.services.gdm-password.enableGnomeKeyring = true;
  security.pam.services.sddm-password.enableGnomeKeyring = true;
  services.displayManager.sddm = {
    # package = lib.mkForce sddmVT1;
    enable = lib.mkDefault true;
    enableHidpi = true;
    theme = "breeze";
    wayland.enable = false;
    wayland.compositor = "kwin";
    # settings.General.DisplayServer = "x11-user";
  };
  environment.systemPackages = with pkgs; [
    (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background = "${background-package}"
    '')
  ];

}
