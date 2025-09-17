
{ config, lib, pkgs, inputs, ... }:
{
 programs.neovim.plugins = [
   pkgs.vimPlugins.nvim-treesitter.withAllGrammars
 ];
}
