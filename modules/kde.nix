{ config, lib, pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    # Missing packages for KIO GDrive
    (final: prev: {
      kdePackages = prev.kdePackages // {
        signon-plugin-oauth2 = final.kdePackages.callPackage ../packages/signon-plugin-oauth2 { };
        signond = final.kdePackages.callPackage ../packages/signond {
          inherit (final.kdePackages) signon-plugin-oauth2;
        };
        signon-ui = final.kdePackages.callPackage ../packages/signon-ui { };
        wallpaper-engine-plugin = prev.kdePackages.wallpaper-engine-plugin.overrideAttrs (old: {
          # version = "0.5.4-unstable-2025-06-29-dirty";
          patches = (old.patches or []) ++ [ 
            ./kde-patches/cmake_update.patch
            ./kde-patches/wallpaper_engine.patch
          ];
        });
      };
      kde-rounded-corners = prev.kde-rounded-corners.overrideAttrs (old: {
        # version = "0.8.5-dirty";
        # src = old.src.override {
        #   rev = "806b6cde5ef2c1a03d3c1596168edf635d5d2132";
        # #     hash = "sha256-00000000000000000000000000000000000000000000";
        # };
        patches = (old.patches or []) ++ [ ./kde-patches/rounded_corner_cmake.patch ];
      });
    })
  ];
  # services.displayManager.gdm.enable = lib.mkForce false;
  # services.displayManager.gdm.wayland = lib.mkForce false;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.plasma6.enableQt5Integration = true;
  services.displayManager.defaultSession = "plasma";
  # programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
  programs.kdeconnect.enable = true;
  # services.accounts-daemon.enable = true;
  # services.gnome.gnome-settings-daemon.enable = true;
  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.sddm.enableGnomeKeyring = true;
  # security.pam.services.gdm.enableGnomeKeyring = true;
  # security.pam.services.gdm-password.enableGnomeKeyring = true;
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID"; # set the runtime directory
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  environment.systemPackages = with pkgs; [
    kdePackages.qtbase
    kde-rounded-corners
    kdePackages.wallpaper-engine-plugin
    kdePackages.sddm-kcm
    kdePackages.accounts-qt
    kdePackages.calendarsupport
    kdePackages.flatpak-kcm
    kdePackages.kdepim-runtime
    kdePackages.kdepim-addons
    kdePackages.akonadi
    kdePackages.kaccounts-integration
    kdePackages.kaccounts-providers
    kdePackages.kio-gdrive
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.dynamic-workspaces
    kdePackages.qtmultimedia
    kdePackages.kzones
    kdePackages.krfb
    kdePackages.layer-shell-qt
    kdePackages.qtwebsockets
    kdePackages.qt5compat
    kdePackages.qtpositioning
    kdiff3
    glava
    papirus-icon-theme
    darkly
    nur.repos.shadowrz.klassy-qt6
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
    # (kdePackages.signond.override {
    #   withOAuth2 = true;
    #   withKWallet = true;
    # })
    # kdePackages.signon-plugin-oauth2
    # kdePackages.signon-ui
  ];
  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   # kdeconnect
  #   ksshaskpass
  # ];
}

