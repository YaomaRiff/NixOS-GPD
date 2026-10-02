{ config, pkgs, lib, zen-browser, system, ... }:

{
  home.packages = with pkgs; [
    zen-browser.packages.${system}.twilight
    firefox
    rhythmbox
    nodejs_24
    typescript
    yarn
    ffmpeg
    gimp
    krita
    kdePackages.okular
    bat
    eza
    ripgrep
    fd
    zoxide
    fzf
    mousepad
    reaper
    audacity
    qsynth
    qpwgraph
    blender
    glslviewer
    git
    lazygit
    delta
    zed-editor
    kitty
    mpv
    btop
    yazi
    ueberzugpp
    ffmpegthumbnailer
    poppler-utils
    jq
  ];

  home.file.".npmrc".text = ''
    prefix=''${HOME}/.npm-global
  '';

  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];
}
