{ config, pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [
    tiling-assistant    # 分屏增强（拖拽弹窗补位）
    appindicator        # 系统托盘图标
    caffeine            # 顶栏禁睡眠开关
    blur-my-shell       # 毛玻璃
    just-perfection     # UI 元素总开关
    vitals              # 顶栏 CPU/内存/网速
    clipboard-history   # 剪贴板历史
  ];

  # 扩展启用列表（含之前的 kimpanel）
  dconf.settings = {
    "org/gnome/shell" = {
      "enabled-extensions" = [
        "kimpanel@kde.org"
        "tiling-assistant@leleat-on-github"
        "appindicatorsupport@rgcjonas.gmail.com"
        "caffeine@patapon.info"
        "blur-my-shell@aunetx"
        "just-perfection-desktop@just-perfection"
        "Vitals@CoreCoding.com"
        "clipboard-history@alexsaveau.dev"
      ];
    };
  };
}
