{ config, pkgs, lib, ... }:

{
  imports = [
    ./packages.nix
    ./shell.nix
    ./terminal.nix
    ./scripts.nix
    ./fcitx5.nix
    ./gnome-extensions.nix
  ];

  home = {
    username = "Traversal";
    homeDirectory = "/home/Traversal";
    stateVersion = "26.05";
  };

  fonts.fontconfig.enable = false;
  programs.home-manager.enable = true;

  dconf.settings = {
    "org/gnome/desktop/session" = {
      "idle-delay" = 0;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      "sleep-inactive-ac-timeout" = 0;
      "sleep-inactive-battery-timeout" = 0;
      "idle-dim" = false;
    };
    "org/gnome/desktop/screensaver" = {
      "lock-enabled" = false;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = "org.xfce.mousepad.desktop";
      "text/markdown" = "org.xfce.mousepad.desktop";
      "text/x-markdown" = "org.xfce.mousepad.desktop";
      "text/xml" = "org.xfce.mousepad.desktop";
      "text/html" = "org.xfce.mousepad.desktop";
      "text/css" = "org.xfce.mousepad.desktop";
      "text/javascript" = "org.xfce.mousepad.desktop";
      "text/x-python" = "org.xfce.mousepad.desktop";
      "text/x-rust" = "org.xfce.mousepad.desktop";
      "text/x-shellscript" = "org.xfce.mousepad.desktop";
      "application/json" = "org.xfce.mousepad.desktop";
      "application/xml" = "org.xfce.mousepad.desktop";
      "application/x-yaml" = "org.xfce.mousepad.desktop";
      "application/toml" = "org.xfce.mousepad.desktop";
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";
      "video/x-msvideo" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/x-flv" = "mpv.desktop";
      "video/3gpp" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/mp4" = "mpv.desktop";
      "audio/x-wav" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/x-vorbis+ogg" = "mpv.desktop";
      "audio/aac" = "mpv.desktop";
      "audio/opus" = "mpv.desktop";
      "audio/webm" = "mpv.desktop";
      "x-scheme-handler/http" = "zen-twilight.desktop";
      "x-scheme-handler/https" = "zen-twilight.desktop";
      "x-scheme-handler/about" = "zen-twilight.desktop";
      "x-scheme-handler/unknown" = "zen-twilight.desktop";
      "application/pdf" = "org.kde.okular.desktop";
    };
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";
    EDITOR = "nano";
    VISUAL = "mousepad";
  };
}
