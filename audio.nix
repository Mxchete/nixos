{ config, pkgs, lib, ... }:

let
  snd-ucm-conf = pkgs.alsa-ucm-conf.overrideAttrs {
    wttsrc = pkgs.fetchFromGitHub {
      owner = "alsa-project";
      repo = "alsa-ucm-conf";
      rev = "v1.2.14";
      sha256 = "sha256-U/gMam8veX3nrmP3X8EdWGQjC5AbcxadTelUXwIVhFA=";
    };
    # unpackPhase = ''
    #   runHook preUnpack
    #   tar xf "$src"
    #   tar xf "$wttsrc"
    #   runHook postUnpack
    # '';
    # installPhase = ''
    #   runHook preInstall
    #   mkdir -p $out/share/alsa
    #   cp -r alsa-ucm*/{ucm,ucm2} $out/share/alsa
    #   runHook postInstall
    # '';
  };
in
{
  environment = {
    systemPackages = with pkgs; [
      # alsa-ucm-conf
      sof-firmware
    ];
    sessionVariables.ALSA_CONFIG_UCM2 = "${snd-ucm-conf}/share/alsa/ucm2";
  };
  system.replaceDependencies.replacements = [
    ({
      original = pkgs.alsa-ucm-conf;
      replacement = snd-ucm-conf;
    })
  ];
}
