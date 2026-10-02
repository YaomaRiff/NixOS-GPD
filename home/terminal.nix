{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;
      background_opacity = "0.64";
      background_blur = 20;
      dynamic_background_opacity = "yes";
      foreground = "#cdd6f4";
      background = "#1e1e2e";
      cursor = "#f5e0dc";
      cursor_shape = "block";
      cursor_blink_interval = 0;
      window_padding_width = 10;
    };
  };
}
