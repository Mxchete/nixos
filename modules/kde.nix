{ config, lib, pkgs, inputs, ... }:

{
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
    kdePackages.dynamic-workspaces
    kdePackages.qtmultimedia
    glava
    papirus-icon-theme
    darkly
    nur.repos.shadowrz.klassy-qt6
    inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
    # kdePackages.signond
    signond
  ];
  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   # kdeconnect
  #   ksshaskpass
  # ];
}

