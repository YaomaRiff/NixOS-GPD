{ config, lib, pkgs, ... }:

{
  # 如果以后有其他脚本，可以在这里继续添加 mkOutOfStoreSymlink
  home.file = { };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # 清理旧的 clash-verge 别名
  programs.zsh.shellAliases = { };
}
