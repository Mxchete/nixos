{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./home-configuration.nix
    ./modules/shell
    ./modules/wm/hyprland
  ];
  wayland.windowManager.hyprland = { };
}
