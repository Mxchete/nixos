{ config, lib, pkgs, inputs, ... }:

{
  # Makes kde better according to <github link>
  nixpkgs.overlays = lib.singleton (final: prev: {
    kdePackages = prev.kdePackages // {
      wallpaper-engine-plugin-new = prev.kdePackages.wallpaper-engine-plugin.overrideAttrs (old: {
        version = "0.5.4-unstable-2025-12-14-dirty";
        src = prev.fetchFromGitHub {
          owner = "catsout";
          repo = "wallpaper-engine-kde-plugin";
          rev = "f1b86e1ca7982b5b9f47d21ac2cb5c2adfb45902";
          # hash = "sha256-zEpELmuK+EvQ1HIWxCSAGyJAjmGgp0yqjtNuC2DTES8=";
          hash = "sha256-otdfGa63w1TfMhYFBauJvxV90OqLqJSEvWB2j0W0E5g=";
          fetchSubmodules = true;
        };
        patches = [ 
          # ./kde-patches/cmake_update.patch
          ./kde-patches/wallpaper_engine.patch
        ];
      });
      plasma-workspace = let

        # the package we want to override
        basePkg = prev.kdePackages.plasma-workspace;

        # a helper package that merges all the XDG_DATA_DIRS into a single directory
        xdgdataPkg = pkgs.stdenv.mkDerivation {
          name = "${basePkg.name}-xdgdata";
          buildInputs = [ basePkg ];
          dontUnpack = true;
          dontFixup = true;
          dontWrapQtApps = true;
          installPhase = ''
            mkdir -p $out/share
            ( IFS=:
              for DIR in $XDG_DATA_DIRS; do
                if [[ -d "$DIR" ]]; then
                  cp -r $DIR/. $out/share/
                  chmod -R u+w $out/share
                fi
              done
            )
          '';
        };

        # undo the XDG_DATA_DIRS injection that is usually done in the qt wrapper
        # script and instead inject the path of the above helper package
        derivedPkg = basePkg.overrideAttrs {
          preFixup = ''
            for index in "''${!qtWrapperArgs[@]}"; do
              if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                unset -v "qtWrapperArgs[$((index+0))]"
                unset -v "qtWrapperArgs[$((index+1))]"
                unset -v "qtWrapperArgs[$((index+2))]"
                unset -v "qtWrapperArgs[$((index+3))]"
              fi
            done
            qtWrapperArgs=("''${qtWrapperArgs[@]}")
            qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
            qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
          '';
        };

      in derivedPkg;
    };
  });
  # nixpkgs.overlays = [
  #   # Missing packages for KIO GDrive
  #   (final: prev: {
  #     kdePackages = prev.kdePackages // {
  #       signon-plugin-oauth2 = final.kdePackages.callPackage ../packages/signon-plugin-oauth2 { };
  #       signond = final.kdePackages.callPackage ../packages/signond {
  #         inherit (final.kdePackages) signon-plugin-oauth2;
  #       };
  #       signon-ui = final.kdePackages.callPackage ../packages/signon-ui { };
  #       wallpaper-engine-plugin = prev.kdePackages.wallpaper-engine-plugin.overrideAttrs (old: {
  #         # version = "0.5.4-unstable-2025-06-29-dirty";
  #         extraCmakeFlags = (old.extraCmakeFlags or []) ++ [ "-DCMAKE_BUILD_TYPE=Debug" ];
  #         patches = (old.patches or []) ++ [ 
  #           ./kde-patches/cmake_update.patch
  #           ./kde-patches/wallpaper_engine.patch
  #         ];
  #         # installPhase = ''
  #         #   runHook preInstall
  #         #
  #         #   ${old.installPhase or "cmake --install . --prefix=$out"}
  #         #
  #         #   if [ -f "${"$"}{PWD}/sceneviewer" ]; then
  #         #     mkdir -p "$out/bin"
  #         #     cp sceneviewer "$out/bin/"
  #         #   fi
  #         #
  #         #   runHook postInstall
  #         # '';
  #       });
  #     };
  #     # kde-rounded-corners = prev.kde-rounded-corners.overrideAttrs (old: {
  #     #   # version = "0.8.5-dirty";
  #     #   # src = old.src.override {
  #     #   #   rev = "806b6cde5ef2c1a03d3c1596168edf635d5d2132";
  #     #   # #     hash = "sha256-00000000000000000000000000000000000000000000";
  #     #   # };
  #     #   patches = (old.patches or []) ++ [ ./kde-patches/rounded_corner_cmake.patch ];
  #     # });
  #   })
  # ];
  # services.displayManager.gdm.enable = lib.mkForce false;
  # services.displayManager.gdm.wayland = lib.mkForce false;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.plasma6.enableQt5Integration = true;
  services.displayManager.defaultSession = "plasma";
  # programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
  programs.kdeconnect.enable = true;
  # services.accounts-daemon.enable = true;
  # services.gnome.gnome-settings-daemon.enable = true;
  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.sddm.enableGnomeKeyring = true;
  # security.pam.services.gdm.enableGnomeKeyring = true;
  # security.pam.services.gdm-password.enableGnomeKeyring = true;
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID"; # set the runtime directory
  environment.variables.POWERDEVIL_NO_DDCUTIL = "1";
  environment.variables.KWIN_USE_OVERLAYS = "1";
  environment.variables.QT_WAYLAND_HARDWARE_INTEGRATION = "linux-dmabuf-unstable-v1";
  environment.variables.GTK_IM_MODULE = lib.mkForce null;
  environment.variables.QT_IM_MODULE = lib.mkForce null;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  environment.systemPackages = with pkgs; [
    kdePackages.qtbase
    kde-rounded-corners
    kdePackages.wallpaper-engine-plugin-new
    kdePackages.sddm-kcm
    kdePackages.accounts-qt
    kdePackages.calendarsupport
    kdePackages.flatpak-kcm
    kdePackages.kdepim-runtime
    kdePackages.kdepim-addons
    kdePackages.akonadi
    kdePackages.kaccounts-integration
    kdePackages.kaccounts-providers
    kdePackages.kio-gdrive
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.dynamic-workspaces
    kdePackages.qtmultimedia
    kdePackages.kzones
    kdePackages.krfb
    kdePackages.layer-shell-qt
    kdePackages.qtwebsockets
    kdePackages.qt5compat
    kdePackages.qtpositioning
    kdiff3
    glava
    papirus-icon-theme
    darkly
    klassy
    inputs.kwin-effects-forceblur.packages.${pkgs.stdenv.hostPlatform.system}.default
    # (kdePackages.signond.override {
    #   withOAuth2 = true;
    #   withKWallet = true;
    # })
    # kdePackages.signon-plugin-oauth2
    # kdePackages.signon-ui
  ];
  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
  #   # kdeconnect
  #   ksshaskpass
  # ];
}

