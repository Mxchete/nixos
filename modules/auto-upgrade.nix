{ config, pkgs, inputs, ... }:
let
  username = "mxchete";
  flakePath = "/etc/nixos/";
in
{
  systemd.services = {
    flake-update = {
      preStart = "${pkgs.host}/bin/host example.com"; # Check network connectivity
      unitConfig = {
        Description = "Update flake inputs";
        StartLimitIntervalSec = 300;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        ExecStart = "${pkgs.nix}/bin/nix flake update --commit-lock-file --flake ${flakePath}";
        Restart = "on-failure";
        RestartSec = "30";
        Type = "oneshot"; # Ensure that it finishes before starting nixos-upgrade
        User = username;
      };
      before = [ "nixos-upgrade.service" ];
      requiredBy = [ "nixos-upgrade.service" ];
      path = [ pkgs.nix pkgs.git pkgs.host ];
    };
  };

  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    flake = inputs.self.outPath;
  };
}
