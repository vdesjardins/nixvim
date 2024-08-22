{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  inherit (lib.nixvim) defaultNullOpts toLuaObject;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin config {
  name = "vscode";
  isColorscheme = true;
  originalName = "vscode-nvim";
  defaultPackage = pkgs.vimPlugins.vscode-nvim;
  colorscheme = null; # Color scheme is set by `require.("vscode").load()`
  callSetup = false;

  maintainers = [ maintainers.loicreynier ];

  settingsOptions = {
    transparent = defaultNullOpts.mkBool false "Whether to enable transparent background";
    italic_comments = defaultNullOpts.mkBool false "Whether to enable italic comments";
    underline_links = defaultNullOpts.mkBool false "Whether to underline links";
    disable_nvimtree_bg = defaultNullOpts.mkBool true "Whether to disable nvim-tree background";
    color_overrides = defaultNullOpts.mkAttrsOf types.str { } ''
      A dictionary of color overrides.
      See https://github.com/Mofiqul/vscode.nvim/blob/main/lua/vscode/colors.lua for color names.
    '';
    group_overrides = defaultNullOpts.mkAttrsOf types.highlight { } ''
      A dictionary of group names, each associated with a dictionary of parameters
      (`bg`, `fg`, `sp` and `style`) and colors in hex.
    '';
  };

  extraConfig = cfg: {
    extraConfigLuaPre = ''
      local _vscode = require("vscode")
      _vscode.setup(${toLuaObject cfg.settings})
      _vscode.load()
    '';
  };
}
