# modules/neovim.nix
{ pkgs, ... }:
{
  globals.mapleader = " ";

  opts = {
    number = true;
    relativenumber = true;
    shiftwidth = 2;
    expandtab = true;
  };

  colorschemes.tokyonight.enable = true;

  plugins = {
    lualine.enable = true;
    which-key.enable = true;
    telescope.enable = true;
    treesitter.enable = true;
    lsp = {
      enable = true;
      servers = {
        lua_ls.enable = true;
        nixd.enable = true;
      };
    };
  };
}
