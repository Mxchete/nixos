# modules/fonts.nix
{pkgs, ...}:
{
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
    ];
  };
}
