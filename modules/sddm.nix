{ config, lib, pkgs, inputs, ... }:

let
  background-package = pkgs.stdenvNoCC.mkDerivation {
    name = "background-images";
    src = ./sddm_background;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/backgrounds
      cp $src/* $out/share/backgrounds/
    '';
  };
  sddm-theme = inputs.silentSDDM.packages.${pkgs.system}.default.override {
    theme = "default"; # select the config of your choice
    theme-overrides = {
      "General" = {
        animated-background-placeholder = "${background-package}/share/backgrounds/jake_the_dog.png";
      };
      "LoginScreen" = {
        background = "${background-package}/share/backgrounds/jake_the_dog.mp4";
      };
    };
  };
in
{
  # From https://github.com/uiriansan/SilentSDDM?tab=readme-ov-file#NixOS-flake
  environment.systemPackages = [
    sddm-theme
    sddm-theme.test
    (pkgs.sddm-astronaut.override { embeddedTheme = "pixel_sakura"; })
  ];
  qt.enable = true;

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
    package = lib.mkDefault pkgs.kdePackages.sddm;
    enable = lib.mkDefault true;
    enableHidpi = true;
    # Theme & extraPackages & settings General from
    # https://github.com/uiriansan/SilentSDDM?tab=readme-ov-file#NixOS-flake
    theme = sddm-theme.pname;
    extraPackages = sddm-theme.propagatedBuildInputs;
    wayland.enable = true;
    wayland.compositor = "kwin";
    settings = {
      Theme.CursorTheme = "Adwaita";
      General = {
        GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
        InputMethod = "qtvirtualkeyboard";
      };
    };
  };
}
