{ config, lib, pkgs, inputs, ... }:
{
  # programs.ax-shell = {
  #   enable = true;
  # };
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     hyprspace = prev.
  #   })
  # ];
  # programs.dankMaterialShell.enable = true;

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd = {
      enable = false;
      variables = [ "--all" ];
    };
    # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      # pkgs.hyprlandPlugins.hyprexpo
      # inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
      # inputs.hy3.packages.x86_64-linux.hy3
      # pkgs.hyprlandPlugins.hypr-dynamic-cursors
      # pkgs.hyprlandPlugins.hy3
      # inputs.gloview.packages.${pkgs.stdenv.hostPlatform.system}.gloview
      # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
    ];
    # https://mynixos.com/home-manager/option/wayland.windowManager.hyprland.settings
    settings.mod = {
      _var = "SUPER";
    };

    settings.config = {
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;

        allow_tearing = true;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "0xee1a1a1a";
        };
      };
    };

    settings.bind = [
      {
        _args = [
          (lib.generators.mkLuaInline "mod .. \" + TAB\"")
          (lib.generators.mkLuaInline "hl.plugin.gloview.toggle")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mod .. \" + Q\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"ghostty\")")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mod .. \" + M\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'\")")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mod .. \" + SPACE\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wofi\")")
        ];
      }
    ];

    settings.env = [
      {
        _args = [
          (lib.generators.mkLuaInline "\"HYPRCURSOR_THEME\"")
          (lib.generators.mkLuaInline "\"Bibata-Modern-Classic\"")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "\"HYPRCURSOR_SIZE\"")
          (lib.generators.mkLuaInline "\"24\"")
        ];
      }
    ];
  };
  # wayland.windowManager.hyprland.settings = {
  #   "$mod" = "SUPER";
  #   bind =
  #     [
  #       "$mod, T, exec, ghostty"
  #       "$mod, F, exec, firefox"
  #       ", Print, exec, grimblast copy area"
  #     ]
  #     ++ (
  #       # workspaces
  #       # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
  #       builtins.concatLists (builtins.genList
  #         (i:
  #           let ws = i + 1;
  #           in
  #           [
  #             "$mod, code:1${toString i}, workspace, ${toString ws}"
  #             "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
  #           ]
  #         )
  #         9)
  #     );
  # };
}
