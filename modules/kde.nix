{ config, lib, pkgs, ... }:

{
  # services.displayManager.gdm.enable = lib.mkForce false;
  # services.displayManager.gdm.wayland = lib.mkForce false;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
  programs.kdeconnect.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  environment.systemPackages = with pkgs; [
    kde-rounded-corners
    kdePackages.wallpaper-engine-plugin
    kdePackages.sddm-kcm
    papirus-icon-theme
    nur.repos.shadowrz.klassy-qt6
  ];
  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   # kdeconnect
  #   ksshaskpass
  # ];
}

