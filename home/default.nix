{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    # inputs.ax-shell.homeManagerModules.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    ./home-configuration.nix
    ./modules/shell
    ./modules/wm/hyprland
    ./modules/hypr/hyprlock
    ./modules/bar/waybar
    ./modules/wofi
    ./modules/programs/neovim
    ./modules/programs/caelestia
    # ./modules/hypr/hyprpanel
  ];
  # programs.ax-shell = {
  #   enable = true;
    # package = inputs.ax-shell.packages.ax-shell;
  # };
  wayland.windowManager.hyprland = { };
}
