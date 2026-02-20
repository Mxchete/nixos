{ config, lib, pkgs, ...}:

let 
  kara-git = with pkgs; stdenv.mkDerivation rec {
    pname = "kara-git";
    version = "2c9f7926d2da41324e9f56355be314a5c76fe022";
    src = fetchFromGitHub {
      owner = "dhruv8sh";
      repo = "kara";
      rev = version;
      hash = "sha256-otdfGa63w1TfMhYFBauJvxV90OqLqJSEvWB2j0W0E5g=";
    };

    nativeBuildInputs = [
      cmake
      kdePackages.extra-cmake-modules
      makeWrapper
    ];

    buildInputs = [
      kdePackages.plasma-desktop
    ];

    cmakeFlags = [
      (lib.cmakeBool "INSTALL_PLASMOID" true)
      (lib.cmakeBool "BUILD_PLUGIN" true)
      (lib.cmakeFeature "Qt6_DIR" "${kdePackages.qtbase}/lib/cmake/Qt6")
      # "-DUSE_PLASMAPKG=OFF"
      # "-DQt6_DIR=${qt6Packages.qtbase}/lib/cmake/Qt6"
      # "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    ];
    dontWrapQtApps = true;

    # postInstall = ''
    # '';
  };
in 

{
  options.nixos = {
    pkgs.kara-git = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kara-git-plugin.";
      };
    };
  };

  config = lib.mkIf (config.nixos.pkgs.kara-git.enable) {
    environment.systemPackages = with pkgs; [
      kara-git
    ];
  };
}
