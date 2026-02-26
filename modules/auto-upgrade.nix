{ config, pkgs, inputs, ... }:
let
  username = "mxchete";
  flakePath = "/etc/nixos/";
in
{
  # systemd.services = {
  #   flake-update = {
  #     preStart = "${pkgs.host}/bin/host example.com"; # Check network connectivity
  #     unitConfig = {
  #       Description = "Update flake inputs";
  #       StartLimitIntervalSec = 300;
  #       StartLimitBurst = 5;
  #     };
  #     serviceConfig = {
  #       ExecStart = "${pkgs.nix}/bin/nix flake update --commit-lock-file --flake ${flakePath}";
  #       Restart = "on-failure";
  #       RestartSec = "30";
  #       Type = "oneshot"; # Ensure that it finishes before starting nixos-upgrade
  #       User = username;
  #     };
  #     before = [ "nixos-upgrade.service" ];
  #     requiredBy = [ "nixos-upgrade.service" ];
  #     path = [ pkgs.nix pkgs.git pkgs.host ];
  #   };
  # };

  system.autoUpgrade = {
    enable = true;
    dates = "06:00";
    persistent = true;
    operation = "boot";
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--recreate-lock-file"
    ];
  };
  # systemd.services.nixos-upgrade = {
  #   preStart = "${pkgs.host}/bin/host example.com";
  #   serviceConfig = {
  #     Restart = "on-failure";
  #     RestartSec = "120";
  #   };
  #   unitConfig = {
  #     StartLimitIntervalSec = 600;
  #     StartLimitBurst = 2;
  #   };
  #   after = [ "flake-update.service" ];
  #   wants = [ "flake-update.service" ];
  #   path = [ pkgs.host ];
  # };

  systemd.services.nixos-upgrade.onFailure = [ "notify-failure@nixos-upgrade.service" ];
  systemd.services."notify-failure@" = {
    enable = true;
    description = "Failure notification for %i";
    path = [ pkgs.nix ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.libnotify}/bin/notify-send "nixos-upgrade.service: Build Failure :(  Please retry the update manually" && exit
      '';
    };
  };
}
