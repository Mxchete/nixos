{ config, lib, pkgs, ... }:
{
  specialisation = {
    gnome.configuration = {
      services.displayManager.gdm.enable = true;
      services.displayManager.gdm.wayland = true;
      services.desktopManager.gnome.enable = true;
      services.udev.packages = [ pkgs.gnome-settings-daemon ];
      services.sysprof.enable = true;
      services.dbus.packages = with pkgs; [ gnome2.GConf ];
      hardware.sensor.iio.enable = true;
      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };
      programs.kdeconnect = {
        enable = true;
        package = pkgs.gnomeExtensions.gsconnect;
      };
      environment.systemPackages = with pkgs.gnomeExtensions; [
        blur-my-shell
        appindicator
        arcmenu
        bluetooth-battery-meter
        brightness-control-using-ddcutil
        burn-my-windows
        caffeine
        clipboard-indicator
        dynamic-calendar-and-clocks-icons
        foresight
        fullscreen-to-empty-workspace
        fuzzy-app-search
        gsconnect
        just-perfection
        kando-integration
        media-progress
        osd-volume-number
        quick-settings-tweaker
        rounded-window-corners-reborn
        window-is-ready-remover
        window-title-is-back
        # ...
      ];
    };

    kde.configuration = {
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      services.desktopManager.plasma6.enable = true;
    };
  };
}
