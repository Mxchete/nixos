{ config
, stdenv
, lib
, pkgs
, fetchFromGitHub
, gnumake
, readline
,
}:
stdenv.mkDerivation rec {
  pname = "bible-drv";
  version = "v1.1";

  src = fetchFromGitHub {
    owner = "BryceVandegrift";
    repo = "drv";
    rev = "v1.1";
    hash = "sha256-tscKD39KOxAnBj+nnsxueWcZn5HgIcMkhg/rAx4cC84=";
  };

  nativeBuildInputs = [ readline gnumake ];

  buildInputs = [ ];

  # buildPhase = ''
  #   make drv
  # '';

  installPhase = ''
    ls -al
    mkdir -p $out/bin
    install -m 755 drv $out/bin/drv
  '';
}
