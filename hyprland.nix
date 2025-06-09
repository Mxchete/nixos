{ config, lib, pkgs, inputs, ... }:
{
  programs.hyprland.enable = true; # enable Hyprland

  environment.systemPackages = with pkgs; [
    # ... other packages
    pkgs.kitty # required for the default Hyprland config
  ];

  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
