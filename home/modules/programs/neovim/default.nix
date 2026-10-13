
{ config, lib, pkgs, inputs, ... }:
{
  # enableMan = false;
  # Import all your configuration modules here
  # imports = [
  #   ./lib
  #   ./autocmd.nix
  #   ./keymaps.nix
  #   ./settings.nix
  #   ./plugins
  # ];

  # extraPackages = with pkgs; [
  #   ripgrep
  #   lazygit
  #   fzf
  #   fd
  # ];

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withAllGrammars)
    ];

    extraLuaConfig = ''
      require('config.lazy')
    '';
  };
}
