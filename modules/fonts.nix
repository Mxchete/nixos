# modules/fonts.nix
{ pkgs, ... }:
{
  nixpkgs.overlays = [ (final: prev:
    { sddm-astronaut-fonts = prev.sddm-astronaut.overrideAttrs (old: {
      installPhase = 
        ''
          mkdir -p $out/share/fonts
          cp -r $src/Fonts/* $out/share/fonts
        '';
    }); }) ];

  fonts = {
    fontconfig = {
      enable = true;
    };
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji-blob-bin
      noto-fonts-cjk-sans
      nerd-fonts._0xproto
      nerd-fonts.symbols-only
      nerd-fonts.caskaydia-cove
      nerd-fonts.caskaydia-mono
      corefonts
      vista-fonts
      sddm-astronaut-fonts
    ];
  };
}
