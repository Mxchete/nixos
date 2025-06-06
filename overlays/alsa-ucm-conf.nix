self: super:

let
  version = "1.2.14";  # Replace with the latest version
in {
  alsa-ucm-conf-Custom = super.stdenv.mkDerivation rec {
    pname = "alsa-ucm-conf-Custom";
    inherit version;

    src = super.fetchFromGitHub {
      owner = "alsa-project";
      repo = "alsa-ucm-conf";
      rev = "v${version}";
      sha256 = "sha256-U/gMam8veX3nrmP3X8EdWGQjC5AbcxadTelUXwIVhFA=";  # Replace this
    };

    installPhase = ''
      mkdir -p $out/share/alsa
      cp -r ucm2 $out/share/alsa/
      cp -r ucm $out/share/alsa/
    '';

    # postInstall = ''
    #   ln -s ${alsaUcmConf}/share/alsa/ucm $out/share/alsa/ucm
    # '';

    meta = with super.lib; {
      description = "ALSA Use Case Manager configuration";
      homepage = "https://github.com/alsa-project/alsa-ucm-conf";
      license = licenses.bsd2;
      platforms = platforms.linux;
    };
  };
}

