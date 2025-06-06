{ config, lib, pkgs, ... }:
{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.wayland = true;
  services.udev.packages = [ pkgs.gnome-settings-daemon ];
  services.sysprof.enable = true;
  services.dbus.packages = with pkgs; [ gnome2.GConf ];
  hardware.sensor.iio.enable = true;
  environment.systemPackages = with pkgs.gnomeExtensions; [
      blur-my-shell
      appindicator
      arcmenu
      bluetooth-battery-meter
      burn-my-windows
      caffeine
      clipboard-indicator
      dynamic-calendar-and-clocks-icons
      foresight
      fullscreen-to-empty-workspace
      fuzzy-app-search
      gsconnect
      just-perfection
      media-progress
      osd-volume-number
      rounded-window-corners-reborn
      window-is-ready-remover
      window-title-is-back
      # ...
    ];
}
