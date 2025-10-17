{ config, lib, pkgs, inputs, ... }:

let
  background-package = pkgs.stdenvNoCC.mkDerivation {
    name = "background-images";
    src = ./sddm_background;
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/share/backgrounds
      cp $src/* $out/share/backgrounds/
    '';
  };
  sddm-theme = (inputs.silentSDDM.packages.${pkgs.system}.default.override {
    theme = "default"; # select the config of your choice
    theme-overrides = {
      # "General" = {
      #   animated-background-placeholder = "jake_the_dog.png";
      # };
      # "LoginScreen" = {
      #   background = "jake_the_dog.mp4";
      # };
      "LockScreen" = {
        # background = "frieren_live_uw_reencode.mp4";
        background = "wallpaper.png";
        blur = "0";
        # brightness = "-0.15";
      };
      "LoginScreen" = {
        # background = "frieren_live_uw_reencode.mp4";
        background = "wallpaper.png";
        blur = "30";
        brightness = "-0.1";
      };
    };
  }).overrideAttrs (old: {
    installPhase = old.installPhase + ''
      mkdir -p $out/share/sddm/themes/silent/backgrounds/
      cp -r ${background-package}/share/backgrounds/* $out/share/sddm/themes/silent/backgrounds/
    '';
  });
in
{
  # From https://github.com/uiriansan/SilentSDDM?tab=readme-ov-file#NixOS-flake
  environment.systemPackages = [
    sddm-theme
    pkgs.xsettingsd
    # sddm-theme.test
    (pkgs.sddm-astronaut.override { embeddedTheme = "pixel_sakura"; })

    # Adds a package defining a default icon/cursor theme.
    # Based off of: https://github.com/NixOS/nixpkgs/pull/25974#issuecomment-305997110
    (pkgs.callPackage ({ stdenv }: stdenv.mkDerivation {
      name = "global-cursor-theme";
      unpackPhase = "true";
      outputs = [ "out" ];
      installPhase = ''
        mkdir -p $out/share/icons/default
        cat << EOF > $out/share/icons/default/index.theme
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=Adwaita
        Size=24
        EOF
      '';
    }) {})
  ];
  qt.enable = true;

  # systemd.services."display-manager" = {
  #   conflicts = [ "plymouth-quit.service" ];
  #   preStart = "${pkgs.plymouth}/bin/plymouth deactivate";
  #   script = "/run/current-system/sw/bin/sddm";
  #   startLimitBurst = lib.mkForce 10;
  #   startLimitIntervalSec = lib.mkForce 5;
  #   postStart = "/bin/sh -c 'sleep 5 && ${pkgs.plymouth}/bin/plymouth quit --retain-splash'";
  #   restartIfChanged = false;
  #   enable = true;
  # };
  systemd.services."plymouth-quit-retainer" = {
    after = [ "plymouth-quit.service"];
    conflicts = [ "plymouth-quit.service"];
    serviceConfig = {
      ExecStartPre = "${pkgs.plymouth}/bin/plymouth deactivate";
      ExecStartPost = "${pkgs.plymouth}/bin/plymouth quit --retain-splash";
    };
  };

  # environment.etc."plymouth/plymouthd.conf".text = lib.mkForce ''
  #   [Daemon]
  #   Theme=bgrt
  #   DeviceTimeout=10
  #   ShowDelay=0
  # '';

  # systemd.services."getty@tty7".enable = lib.mkForce false;
  # systemd.services."autovt@tty1".enable = lib.mkForce false;
  # systemd.services."getty@tty1".enable = lib.mkForce false;
  # systemd.services."getty@tty7".enable = lib.mkForce false;
  services.xserver.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
  # security.pam.services.gdm-password.enableGnomeKeyring = true;
  security.pam.services.sddm-password.enableGnomeKeyring = true;
  systemd.services.disable-wall-messages = {
    description = "Disable systemd wall messages";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.systemd}/bin/busctl set-property \
          org.freedesktop.login1 \
          /org/freedesktop/login1 \
          org.freedesktop.login1.Manager \
          EnableWallMessages \
          b false
      '';
    };
  };

  services.displayManager = {
    sddm = {
      package = lib.mkDefault pkgs.kdePackages.sddm;
      enable = lib.mkDefault true;
      enableHidpi = true;
      # Theme & extraPackages & settings General from
      # https://github.com/uiriansan/SilentSDDM?tab=readme-ov-file#NixOS-flake
      theme = sddm-theme.pname;
      extraPackages = sddm-theme.propagatedBuildInputs;
      wayland.enable = true;
      wayland.compositor = "kwin";
      settings = {
        Theme.CursorTheme = "Adwaita";
        Theme.CursorSize = "24";
        X11.ServerArguments="-terminate -logfile /dev/null";
        General = {
          # GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard,QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
          GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
          InputMethod = "qtvirtualkeyboard";
          HaltCommand = "/run/current-system/systemd/bin/systemctl poweroff --no-wall";
          RebootCommand = "/run/current-system/systemd/bin/systemctl reboot --no-wall";
        };
        # Wayland = {
        #   CompositorCommand =  "${pkgs.kdePackages.kwin}/bin/kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1";
        # };
      };
    };
  };
}
