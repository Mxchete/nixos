{ config, lib, pkgs, ... }:
{
  specialisation = {
    gnome.configuration = {
      # services.displayManager.gdm.enable = true;
      # services.displayManager.gdm.wayland = true;
      services.displayManager.sddm.enable = lib.mkForce false;
      services.displayManager.sddm.wayland.enable = lib.mkForce false;
      services.desktopManager.gnome.enable = true;
      # services.desktopManager.plasma6.enable = lib.mkForce false;
      services.udev.packages = [ pkgs.gnome-settings-daemon ];
      services.displayManager.defaultSession = lib.mkForce "gnome";
      services.sysprof.enable = true;
      services.dbus.packages = with pkgs; [ gnome2.GConf ];
      hardware.sensor.iio.enable = true;
      qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
      };
      programs.kdeconnect = lib.mkForce {
        enable = true;
        package = pkgs.gnomeExtensions.gsconnect;
      };
      environment.systemPackages = with pkgs.gnomeExtensions; [
        gsconnect
        # ...
      ];
    };
  };
}
