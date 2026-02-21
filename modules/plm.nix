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
in
{
  # From https://github.com/uiriansan/SilentSDDM?tab=readme-ov-file#NixOS-flake
  environment.systemPackages = [
    pkgs.xsettingsd
    # Adds a package defining a default icon/cursor theme.
    # Based off of: https://github.com/NixOS/nixpkgs/pull/25974#issuecomment-305997110
    (pkgs.callPackage ({ stdenv }: stdenv.mkDerivation {
      name = "global-cursor-theme";
      unpackPhase = "true";
      outputs = [ "out" ];
      installPhase = ''
        mkdir -p $out/share/icons/default
        cat << EOF > $out/share/icons/default/index.theme
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=Adwaita
        Size=24
        EOF
      '';
    }) {})
  ];
  qt.enable = true;

  systemd.services.plymouth-quit-retainer = {
    enable = lib.mkForce true;
    after = [ "plymouth-quit.service"];
    conflicts = [ "plymouth-quit.service"];
    serviceConfig = {
      ExecStart = "${pkgs.plymouth}/bin/plymouth deactivate";
      ExecStop = "${pkgs.plymouth}/bin/plymouth quit --retain-splash";
    };
  };
  services.xserver.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.plasmalogin.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
  # security.pam.services.sddm-password.enableGnomeKeyring = true;
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

  services.displayManager = {
    plasma-login-manager = {
      enable = lib.mkDefault true;
    };
  };
}
