{ lib
, fetchFromGitHub
, gnumake
, hyprland
, hyprlandPlugins
,
}:
hyprlandPlugins.mkHyprlandPlugin hyprland {
  pluginName = "csd-titlebar-move";
  version = "0.39.1";

  src = fetchFromGitHub {
    owner = "khalid151";
    repo = "csd-titlebar-move";
    rev = "ee9db13b7955a2b05cc660324d176538772adf17";
    hash = "sha256-219UocltY5RnJfkwmFu3oHuTjjKKsMIm1D41kOgiJqQ=";
  };

  # any nativeBuildInputs required for the plugin
  nativeBuildInputs = [ gnumake ];

  # set any buildInputs that are not already included in Hyprland
  # by default, Hyprland and its dependencies are included
  buildInputs = [ ];

  buildPhase = ''
    make
  '';
  installPhase = ''
    ls -al
    mkdir -p $out/lib
    mv csd-titlebar-move.so libcsd-titlebar-move.so
    cp *.so $out/lib/
  '';

  meta = {
    homepage = "https://github.com/khalid151/csd-titlebar-move";
    description = "A hyprland plugin to help move GTK applications with CSD by their titlebar";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
