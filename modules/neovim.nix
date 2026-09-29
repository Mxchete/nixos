{ pkgs, ... }: {
  globals.mapleader = " ";
  opts = {
    number = true;
    relativenumber = true;
    shiftwidth = 2;
    expandtab = true;
    termguicolors = true;
  };

  colorschemes.tokyonight.enable = true;

  plugins = {
    lualine.enable = true;
    which-key.enable = true;
    telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>/"  = "live_grep";
      };
    };
    treesitter = { enable = true; settings.highlight.enable = true; };
    lsp = {
      enable = true;
      servers = {
        lua_ls.enable = true;
        nixd.enable = true;
      };
    };
    conform-nvim = {
      enable = true;
      settings.formatters_by_ft.lua = [ "stylua" ];
    };
  };

  keymaps = [
    { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<cr>"; }
  ];
}
