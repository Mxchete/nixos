{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./home-configuration.nix
    ./modules/shell
    ./modules/wm/hyprland
    ./modules/hypr/hyprlock
    ./modules/bar/waybar
    ./modules/wofi
    ./modules/programs/neovim
    # ./modules/hypr/hyprpanel
  ];
  wayland.windowManager.hyprland = { };
}
