{ config, lib, pkgs, ... }:

{
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  # environment.systemPackages = with pkgs; [
  #   kde-rounded-corners
  #   kdePackages.wallpaper-engine-plugin
  #   papirus-icon-theme
  # ];
  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   # kdeconnect
  #   ksshaskpass
  # ];
}

