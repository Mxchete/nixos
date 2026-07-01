{ lib
, fetchFromGitHub
, gnumake
,
}:
stdenv.mkDerivation rec {
  pname = "signon-ui";
  version = "0.17-unstable-2023-10-16";

  src = fetchFromGitLab {
    owner = "BryceVandegrift";
    repo = "drv";
    rev = "v1.1";
    hash = "sha256-L37nypdrfg3ZGZE4uGtFoJlzNbFgTVgA36zCgzvzk6E=";
  };

  # any nativeBuildInputs required for the plugin
  nativeBuildInputs = [ gnumake ];

  # set any buildInputs that are not already included in Hyprland
  # by default, Hyprland and its dependencies are included
  buildInputs = [ ];

  buildPhase = ''
    make
  '';
}
