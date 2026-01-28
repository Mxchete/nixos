{ lib
, fetchFromGitLab
, plasma-framework
}:

# https://invent.kde.org/dos/plasma-wallpaper-application
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/kde/third-party/wallpaper-engine-plugin/default.nix

mkKdeDerivation {
  pname = "Application Wallpaper";
  version = "0.0.1-d";

  src = fetchFromGitLab {
    owner = "zeroxoneafour";
    repo = pname;
    rev = "v" + version;
    hash = "sha256-fZgNOcOq+owmqtplwnxeOIQpWmrga/WitCNCj89O5XA=";
  };

  dontConfigure = true;

  nativeBuildInputs = [ plasma-framework ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    plasmapkg2 --install pkg --packageroot $out/share/kwin/scripts
    runHook postInstall
  '';

  meta = with lib; {
    description = "";
    maintainers = with maintainers; [ ];
    inherit (plasma-framework.meta) platforms;
  };
}
