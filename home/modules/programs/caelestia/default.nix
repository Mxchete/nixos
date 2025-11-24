
{ config, lib, pkgs, inputs, ... }:
{
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = false; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
      bar.status = {
        showBattery = false;
      };
      osd = {
        enableBrightness = false;
        enableMicrophone = true;
      };
      background = {
        # enabled = false;
        DesktopClock.enabled = true;
        Visualizer.enabled = true;
      };
      appearance.transparency = {
        enabled = true;
      };
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };
}
