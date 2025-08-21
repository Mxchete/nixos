{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./home-configuration.nix
    ./modules/shell
    ./modules/wm/hyprland
    ./modules/hypr/hyprlock
    ./modules/hypr/hyprpanel
  ];
  wayland.windowManager.hyprland = { };
}
