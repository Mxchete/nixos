{ config, lib, pkgs, inputs, ... }:

{
  programs.labwc.enable = true;
  services.desktopManager.xfce.enable = true;
  services.desktopManager.xfce.enableWaylandSession = true;
}

