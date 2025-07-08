{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./home-configuration.nix
    ./modules/shell
    ./modules/wm/hyprland
    ./modules/hypr/hyprlock
  ];
  wayland.windowManager.hyprland = { };
}
