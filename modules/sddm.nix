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
  nixpkgs.overlays = [ (final: prev:
    { sddm-astronaut = prev.sddm-astronaut.overrideAttrs (old: {
      installPhase = (old.installPhase or "") + ''
          mkdir -p $out/share/fonts
          cp -r $src/Fonts/* $out/share/fonts
        '';
    }); }) ];
  # systemd.services."getty@tty7.service".wantedBy = [ ];
  # services.getty.enable = false;
  # systemd.units."getty@tty1.service" = {
  #   overrideStrategy = "asDropin";
  #   text = ''
  #     [Service]
  #     ExecStart=
  #     ExecStart=-/usr/bin/agetty --skip-login --nonewline --noissue --noclear %I $TERM
  #   '';
  # };
  # systemd.services."autovt@tty7".enable = lib.mkForce true;
  # systemd.services."getty@tty7".enable = lib.mkForce true;
  # systemd.services."autovt@tty1".enable = lib.mkForce false;
  # systemd.services."getty@tty1".enable = lib.mkForce false;
  systemd.services."getty@tty7".enable = lib.mkForce false;
  services.xserver.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
  # security.pam.services.gdm-password.enableGnomeKeyring = true;
  security.pam.services.sddm-password.enableGnomeKeyring = true;
  systemd.services.disable-wall-messages = {
    description = "Disable systemd wall messages";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.systemd}/bin/busctl set-property \
          org.freedesktop.login1 \
          /org/freedesktop/login1 \
          org.freedesktop.login1.Manager \
          EnableWallMessages \
          b false
      '';
    };
  };

  services.displayManager.sddm = {
    # package = lib.mkForce sddmVT1;
    enable = lib.mkDefault true;
    enableHidpi = true;
    theme = "sddm-astronaut-theme";
    wayland.enable = true;
    wayland.compositor = "kwin";
    settings = {
      Theme.CursorTheme = "Adwaita";
    };
    # settings.General.DisplayServer = "x11-user";
  };
  environment.systemPackages = with pkgs; [
    (sddm-astronaut.override { embeddedTheme = "hyprland_kath"; })
    # (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
    #   [General]
    #   background = "${background-package}"
    # '')
  ];

}
