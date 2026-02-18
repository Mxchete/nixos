{ config, lib, pkgs, inputs, ... }:

{
  programs.labwc.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xfce.enableWaylandSession = true;
}

