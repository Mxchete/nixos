{ config, ... }:
{
  programs.hyprlock = {
    enable = true;

    settings = {
      background = {
        path = "/home/mxchete/Pictures/background/wp12468518_up.jpg";

        blur_passes = 2;
        blur_size = 7;

        brightness = 0.8;
        contrast = 0.8;

        # color = "${base00}99";
      };

      input-field = {
        # size = {
        #   width = 200;
        #   height = 20;
        # };

        outline_thickness = 3;
        dots_size = 0.33;
        dots_spacing = 0.15;
        dots_center = false;
        # outer_color = "${base01}";
        # inner_color = "${base07}";
        # font_color = "${base00}";
        fade_on_empty = true;
        placeholder_text = "<i>Input Password...</i>";
        hide_input = false;
        position = {
          x = 0;
          y = -20;
        };
        halign = "center";
        valign = "center";
      };

      label = {
        text = "$TIME";
        # color = "${base05}";
        font_size = 50;
        font_family = "IBM Plex";
        position = {
          x = 0;
          y = 200;
        };
        # halign = "center";
        # valign = "center";
      };
    };
  };
}
