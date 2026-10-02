# 项目快照: /home/Traversal/nixos-config

**生成时间**: 2026-10-02 13:59:07
**文件数**: 21
**总大小**: 28.1 KB

---

## 📁 目录结构

```
📁 /
  ├── 📁 scripts
  ├── 📁 system
    ├── 📄 configuration.nix
  ├── 📁 home
    ├── 📄 terminal.nix
    ├── 📄 gnome-extensions.nix
    ├── 📄 packages.nix
    ├── 📄 default.nix
    ├── 📄 shell.nix
    ├── 📄 fcitx5.nix
    ├── 📄 scripts.nix
  ├── 📄 flake.lock
  ├── 📁 hosts
    ├── 📁 panasonic
      ├── 📄 hardware-configuration.nix
    ├── 📁 lab
      ├── 📄 hardware-configuration.nix
    ├── 📁 gpdmax2
      ├── 📄 hardware-configuration.nix
  ├── 📄 flake.nix
```

---

## 📄 文件列表

1. `system/configuration.nix` (5.8 KB)
2. `home/terminal.nix` (445 B)
3. `home/gnome-extensions.nix` (868 B)
4. `home/packages.nix` (664 B)
5. `home/default.nix` (2.5 KB)
6. `home/shell.nix` (2.3 KB)
7. `home/fcitx5.nix` (3.9 KB)
8. `home/scripts.nix` (258 B)
9. `flake.lock` (5.4 KB)
10. `hosts/panasonic/hardware-configuration.nix` (1.1 KB)
11. `hosts/lab/hardware-configuration.nix` (1.1 KB)
12. `hosts/gpdmax2/hardware-configuration.nix` (1.0 KB)
13. `flake.nix` (2.8 KB)

---

## 📝 文件内容

### `system/configuration.nix`

```nix
{ config, lib, pkgs, ... }:

{
  imports = [ ];

  nixpkgs.config.allowUnfree = true;

  # -- Boot --
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];
  hardware.enableRedistributableFirmware = true;

  # -- Networking --
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    firewall = {
      enable = true;
      checkReversePath = "loose";
      allowedTCPPorts = [ 7890 9090 ]; # 代理端口与 Web UI API
      trustedInterfaces = [  ];
    };
    # 添加系统代理和 noProxy 配置
    proxy = {
      default = "http://127.0.0.1:7890"; # 你的 mihomo 代理地址
      noProxy = "127.0.0.1,localhost,.local"; # 关键：让 127.0.0.1 不走代理
      envVars = {
        http_proxy  = "http://127.0.0.1:7890";
        https_proxy = "http://127.0.0.1:7890";
        all_proxy   = "socks5://127.0.0.1:7890";
        no_proxy    = "127.0.0.1,localhost,::1,.local";
      };
    };
  };

  # -- Virtualization / Containers --
  programs.appimage = { enable = true; binfmt = true; };
  services.flatpak.enable = true;

  # -- Locale --
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";

  # -- Nix --
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" "https://cache.nixos.org" ];
  };

  # -- Desktop --
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # -- Gaming --
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  # -- Fonts --
  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      nerd-fonts.jetbrains-mono
      wqy_microhei
    ];
    fontconfig = {
      defaultFonts = {
        sansSerif = [ "WenQuanYi Micro Hei" "Noto Sans CJK SC" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK SC" ];
      };
    };
  };

  # -- Input Method --
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [ fcitx5-gtk fcitx5-rime ];
    };
  };


  # -- Audio --
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # -- Bluetooth --
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = { Experimental = true; FastConnectable = true; };
      Policy = { AutoEnable = true; ReconnectAttempts = 7; ReconnectIntervals = "1, 2, 4, 8, 16, 32, 64"; };
    };
  };
  services.blueman.enable = true;

  # -- Storage / Mount --
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  boot.supportedFilesystems = [ "ntfs" "exfat" ];

  # -- Power --
  services.upower.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";
    };
  };
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandlePowerKey = "suspend";
  };
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = false;

  # -- SSH --
  services.openssh = {
    enable = true;
    settings = { PermitRootLogin = "no"; PasswordAuthentication = true; };
  };

  # -- Syncthing --
  services.syncthing = {
    enable = true;
    user = "Traversal";
    group = "users";
    dataDir = "/home/Traversal/Sync";
    configDir = "/home/Traversal/.config/syncthing";
    openDefaultPorts = true;
    guiAddress = "127.0.0.1:8384";
    settings.gui = { user = "Traversal"; password = "247454"; };
  };

  # -- Auth --
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  # -- User --
  users.users.Traversal = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "storage" ];
    initialPassword = "247454";
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # -- Session --
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    TERMINAL = "kitty";
    XDG_DATA_DIRS = [
      "${pkgs.shared-mime-info}/share"
      "${pkgs.gdk-pixbuf}/share"
      "${pkgs.librsvg}/share"
    ];
    TUMBLER_MAX_FILE_SIZE = "10485760";
  };

  # -- Packages --
  environment.systemPackages = with pkgs; [
    # Desktop / Daily
    gnomeExtensions.kimpanel
    anydesk
    mihomo        # 内核 (来自 unstable overlay)

    # Archives
    _7zz p7zip unzip zip xz

    # Dev
    vim just rustc cargo rustfmt clippy rust-analyzer pkg-config
    (python3.withPackages (ps: [ ps.pyyaml ]))
    gnumake gcc

    # System monitor
    htop bottom powertop acpi fastfetch

    # Hardware info
    pciutils usbutils dmidecode lm_sensors smartmontools qdiskinfo

    # Network
    wget curl aria2 ethtool lsof bind

    # Disk / File
    tree dust ncdu

    # Process / Debug
    iotop strace ltrace

    # Nix tools
    nix-index comma

    # Gaming
    wineWow64Packages.staging winetricks lutris heroic protonup-qt mangohud ryzenadj

    # Creative
    freecad

    # Misc
    flatpak gnome-software miniserve
  ];

  # -- Tmpfiles --
  systemd.tmpfiles.rules = [
    "d /home/Traversal/Sal 0755 Traversal users - -"
    "Z /home/Traversal/Sal 0755 Traversal users - -"
  ];

  # Mihomo 纯内核 + Web UI（使用模块原生 webui 选项）
  services.mihomo = {
    enable = true;
    configFile = "/etc/mihomo/config.yaml";
    tunMode = false;
    webui = pkgs.metacubexd;
  };

  system.stateVersion = "26.05";
}

```

### `home/terminal.nix`

```nix
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

```

### `home/gnome-extensions.nix`

```nix
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

```

### `home/packages.nix`

```nix
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

```

### `home/default.nix`

```nix
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

```

### `home/shell.nix`

```nix
{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };

    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      ".." = "cd ..";
      "..." = "cd ../..";
      lg = "lazygit";
      cat = "bat --style=plain --paging=never";
      find = "fd";
      grep = "rg";
      copy = "wl-copy";
      proxyon = "export http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890 no_proxy=localhost,127.0.0.1,::1";
      proxyoff = "unset http_proxy https_proxy all_proxy no_proxy";
    };

    initContent = ''
      setopt INTERACTIVE_COMMENTS
      setopt AUTO_CD
      setopt RM_STAR_WAIT
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      eval "$(zoxide init zsh)"
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh

      rebuild() {
        sudo nixos-rebuild switch --flake "$HOME/nixos-config"
      }

      update() {
        cd "$HOME/nixos-config" && nix flake update && sudo nixos-rebuild switch --flake "$HOME/nixos-config"
      }
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$all";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };
      git_status = {
        ahead = "$" + "{count}";
        diverged = "$" + "{ahead_count}/" + "{behind_count}";
        behind = "$" + "{count}";
        style = "bold yellow";
      };
      cmd_duration = {
        min_time = 500;
        format = "took [$duration](bold yellow)";
      };
      time = {
        disabled = false;
        format = "[$time]($style) ";
        style = "bold white";
      };
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "eza -l";
      la = "eza -la";
      rebuild = "sudo nixos-rebuild switch --flake $HOME/nixos-config";
    };
  };
}

```

### `home/fcitx5.nix`

```nix
{ config, pkgs, rime-ice, ... }:

let
  # 雾凇拼音 + 自定义补丁（纯字面文本，无插值，缩进由 heredoc 原样保留）
  # 翻页键: 移除 -/=，启用 ,/.（基于 rime-ice 默认 bindings 完整列表）
  rimeIceWithCustom = pkgs.runCommand "rime-ice-with-custom" { } ''
    mkdir -p $out
    cp -r ${rime-ice}/. $out/
    chmod u+w $out

    cat > $out/default.custom.yaml <<'YAML'
patch:
  schema_list:
    - schema: rime_ice
  menu/page_size: 9
  key_binder/bindings:
    - { when: composing, accept: Shift+Tab, send: Shift+Left }
    - { when: composing, accept: Tab, send: Shift+Right }
    - { when: composing, accept: Alt+Left, send: Shift+Left }
    - { when: composing, accept: Alt+Right, send: Shift+Right }
    - { when: has_menu, accept: comma, send: Page_Up }
    - { when: has_menu, accept: period, send: Page_Down }
    - { when: always, toggle: ascii_punct, accept: Control+Shift+3 }
    - { when: always, toggle: ascii_punct, accept: Control+Shift+numbersign }
    - { when: always, toggle: traditionalization, accept: Control+Shift+4 }
    - { when: always, toggle: traditionalization, accept: Control+Shift+dollar }
    - { accept: KP_0, send: 0, when: composing }
    - { accept: KP_1, send: 1, when: composing }
    - { accept: KP_2, send: 2, when: composing }
    - { accept: KP_3, send: 3, when: composing }
    - { accept: KP_4, send: 4, when: composing }
    - { accept: KP_5, send: 5, when: composing }
    - { accept: KP_6, send: 6, when: composing }
    - { accept: KP_7, send: 7, when: composing }
    - { accept: KP_8, send: 8, when: composing }
    - { accept: KP_9, send: 9, when: composing }
    - { accept: KP_Decimal, send: period, when: composing }
    - { accept: KP_Multiply, send: asterisk, when: composing }
    - { accept: KP_Add, send: plus, when: composing }
    - { accept: KP_Subtract, send: minus, when: composing }
    - { accept: KP_Divide, send: slash, when: composing }
    - { accept: KP_Enter, send: Return, when: composing }
YAML

    cat > $out/rime_ice.custom.yaml <<'YAML'
patch:
  key_binder/bindings:
    - { when: composing, accept: Shift+Tab, send: Shift+Left }
    - { when: composing, accept: Tab, send: Shift+Right }
    - { when: composing, accept: Alt+Left, send: Shift+Left }
    - { when: composing, accept: Alt+Right, send: Shift+Right }
    - { when: has_menu, accept: comma, send: Page_Up }
    - { when: has_menu, accept: period, send: Page_Down }
    - { when: always, toggle: ascii_punct, accept: Control+Shift+3 }
    - { when: always, toggle: ascii_punct, accept: Control+Shift+numbersign }
    - { when: always, toggle: traditionalization, accept: Control+Shift+4 }
    - { when: always, toggle: traditionalization, accept: Control+Shift+dollar }
    - { accept: KP_0, send: 0, when: composing }
    - { accept: KP_1, send: 1, when: composing }
    - { accept: KP_2, send: 2, when: composing }
    - { accept: KP_3, send: 3, when: composing }
    - { accept: KP_4, send: 4, when: composing }
    - { accept: KP_5, send: 5, when: composing }
    - { accept: KP_6, send: 6, when: composing }
    - { accept: KP_7, send: 7, when: composing }
    - { accept: KP_8, send: 8, when: composing }
    - { accept: KP_9, send: 9, when: composing }
    - { accept: KP_Decimal, send: period, when: composing }
    - { accept: KP_Multiply, send: asterisk, when: composing }
    - { accept: KP_Add, send: plus, when: composing }
    - { accept: KP_Subtract, send: minus, when: composing }
    - { accept: KP_Divide, send: slash, when: composing }
    - { accept: KP_Enter, send: Return, when: composing }
YAML
  '';
in
{
  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Vertical Candidate List=False
    PerScreenDPI=True
    Font="Noto Sans CJK SC 16"
    Theme=default
  '';

  xdg.configFile."fcitx5/conf/rime.conf".text = ''
    PreeditInApplication=True
  '';

  home.file.".local/share/fcitx5/rime" = {
    source = rimeIceWithCustom;
    recursive = true;
  };
}

```

### `home/scripts.nix`

```nix
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

```

### `flake.lock`

```lock
{
  "nodes": {
    "flake-utils": {
      "inputs": {
        "systems": "systems"
      },
      "locked": {
        "lastModified": 1731533236,
        "narHash": "sha256-l0KFg5HjrsfsO/JpG+r7fRrqm12kzFHyUHqHCVpMMbI=",
        "owner": "numtide",
        "repo": "flake-utils",
        "rev": "11707dc2f618dd54ca8739b309ec4fc024de578b",
        "type": "github"
      },
      "original": {
        "owner": "numtide",
        "repo": "flake-utils",
        "type": "github"
      }
    },
    "home-manager": {
      "inputs": {
        "nixpkgs": "nixpkgs"
      },
      "locked": {
        "lastModified": 1783740085,
        "narHash": "sha256-qajyHfZY29G2oEQk+uHxmsJcRoBUBXP9maTpFlwP/dI=",
        "type": "tarball",
        "url": "https://ghfast.top/https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz"
      },
      "original": {
        "type": "tarball",
        "url": "https://ghfast.top/https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz"
      }
    },
    "home-manager_2": {
      "inputs": {
        "nixpkgs": [
          "zen-browser",
          "nixpkgs"
        ]
      },
      "locked": {
        "lastModified": 1782839684,
        "narHash": "sha256-vzs4SBgPsK4aNzlJR2PpFwtARazXMOxZonQnDz0YHxk=",
        "owner": "nix-community",
        "repo": "home-manager",
        "rev": "2a37d71bbe69e1522ddabf03a4cea0374958bdbe",
        "type": "github"
      },
      "original": {
        "owner": "nix-community",
        "repo": "home-manager",
        "type": "github"
      }
    },
    "nixpkgs": {
      "locked": {
        "lastModified": 1783549019,
        "narHash": "sha256-0XnckG4ZhBmAsYa9mLuEIFowBG0fDGPLHduQGsbMS4A=",
        "owner": "NixOS",
        "repo": "nixpkgs",
        "rev": "74cc63f702f7d60a557e152a57b40fb1fd0f72ac",
        "type": "github"
      },
      "original": {
        "owner": "NixOS",
        "ref": "nixos-26.05",
        "repo": "nixpkgs",
        "type": "github"
      }
    },
    "nixpkgs-unstable": {
      "locked": {
        "lastModified": 1790822859,
        "narHash": "sha256-69xHQhAeMAD2wDXO7T2pcOZIF9Sga2W+JkmY2a11Ops=",
        "type": "tarball",
        "url": "https://ghfast.top/https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz"
      },
      "original": {
        "type": "tarball",
        "url": "https://ghfast.top/https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz"
      }
    },
    "nixpkgs_2": {
      "locked": {
        "lastModified": 1790750587,
        "narHash": "sha256-VfjaoJ1Uyb7JZTrBgE5Jf2nhjtQPmD9KOd19HJwmZwM=",
        "type": "tarball",
        "url": "https://ghfast.top/https://github.com/NixOS/nixpkgs/archive/nixos-26.05.tar.gz"
      },
      "original": {
        "type": "tarball",
        "url": "https://ghfast.top/https://github.com/NixOS/nixpkgs/archive/nixos-26.05.tar.gz"
      }
    },
    "nixpkgs_3": {
      "locked": {
        "lastModified": 1782723713,
        "narHash": "sha256-oPXCU/SSUokcGaJREHibG1CBX3+s/W7orDWQOZDsEeQ=",
        "owner": "nixos",
        "repo": "nixpkgs",
        "rev": "b5aa0fbd538984f6e3d201be0005b4463d8b09f8",
        "type": "github"
      },
      "original": {
        "owner": "nixos",
        "ref": "nixos-unstable",
        "repo": "nixpkgs",
        "type": "github"
      }
    },
    "rime-ice": {
      "flake": false,
      "locked": {
        "lastModified": 1790337049,
        "narHash": "sha256-qkRHk01UXrgherNi9eJPeKMyOE8yGkx4TF7oDxV+XYQ=",
        "owner": "iDvel",
        "repo": "rime-ice",
        "rev": "3aea6d3694fb3d94ec663641f021f788822897ad",
        "type": "github"
      },
      "original": {
        "owner": "iDvel",
        "repo": "rime-ice",
        "type": "github"
      }
    },
    "root": {
      "inputs": {
        "home-manager": "home-manager",
        "nixpkgs": "nixpkgs_2",
        "nixpkgs-unstable": "nixpkgs-unstable",
        "rime-ice": "rime-ice",
        "treesnap": "treesnap",
        "zen-browser": "zen-browser"
      }
    },
    "systems": {
      "locked": {
        "lastModified": 1681028828,
        "narHash": "sha256-Vy1rq5AaRuLzOxct8nz4T6wlgyUR7zLU309k9mBC768=",
        "owner": "nix-systems",
        "repo": "default",
        "rev": "da67096a3b9bf56a91d16901293e51ba5b49a27e",
        "type": "github"
      },
      "original": {
        "owner": "nix-systems",
        "repo": "default",
        "type": "github"
      }
    },
    "treesnap": {
      "inputs": {
        "flake-utils": "flake-utils",
        "nixpkgs": [
          "nixpkgs"
        ]
      },
      "locked": {
        "lastModified": 1762630306,
        "narHash": "sha256-sELYG3nXT6fyI34fQMOBt53Vgb8LVsKa33ipavMp/iI=",
        "type": "tarball",
        "url": "https://ghfast.top/https://github.com/YaomaRiff/treesnap/archive/nixos.tar.gz"
      },
      "original": {
        "type": "tarball",
        "url": "https://ghfast.top/https://github.com/YaomaRiff/treesnap/archive/nixos.tar.gz"
      }
    },
    "zen-browser": {
      "inputs": {
        "home-manager": "home-manager_2",
        "nixpkgs": "nixpkgs_3"
      },
      "locked": {
        "lastModified": 1783893146,
        "narHash": "sha256-eKn371TzEBL1fbyYMXgmiCMeoJQHe8s6b2lL5Z2vBQc=",
        "type": "tarball",
        "url": "https://ghfast.top/https://github.com/0xc000022070/zen-browser-flake/archive/main.tar.gz"
      },
      "original": {
        "type": "tarball",
        "url": "https://ghfast.top/https://github.com/0xc000022070/zen-browser-flake/archive/main.tar.gz"
      }
    }
  },
  "root": "root",
  "version": 7
}

```

### `hosts/panasonic/hardware-configuration.nix`

```nix
# Do not modify this file!  It was generated by 'nixos-generate-config'
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f4095ac2-8733-41ae-8a27-7fc34da2a764";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7E64-7A03";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/8facf974-7958-4037-b2f1-064abf29de4b"; }
    ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

```

### `hosts/lab/hardware-configuration.nix`

```nix
# Do not modify this file!  It was generated by 'nixos-generate-config'
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/22b4cd5b-f063-490b-9385-ca91558beb99";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/DA4E-B655";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/08195540-4e5f-45f6-b44d-8b313593121c"; }
    ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

```

### `hosts/gpdmax2/hardware-configuration.nix`

```nix
# Do not modify this file!  It was generated by 'nixos-generate-config'
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B1AC-373C";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/7c727388-a350-4cbc-b509-96bb08623472";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d1416352-9b4c-46e5-835e-481c8feb40fe"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

```

### `flake.nix`

```nix
{
  description = "NixOS configuration with Flakes";

  inputs = {
    nixpkgs.url = "https://ghfast.top/https://github.com/NixOS/nixpkgs/archive/nixos-26.05.tar.gz";
    nixpkgs-unstable.url = "https://ghfast.top/https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    
    home-manager.url = "https://ghfast.top/https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
    zen-browser.url = "https://ghfast.top/https://github.com/0xc000022070/zen-browser-flake/archive/main.tar.gz";
    
    treesnap = {
      url = "https://ghfast.top/https://github.com/YaomaRiff/treesnap/archive/nixos.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 雾凇拼音词库（纯数据仓库，不是 flake）
    rime-ice.url = "github:iDvel/rime-ice";
    rime-ice.flake = false;
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, zen-browser, treesnap, rime-ice, ... }:
    let
      system = "x86_64-linux";
      
      # 从 unstable 提取最新内核和 Web UI，覆盖稳定版
      overlay-unstable-tools = final: prev: {
        mihomo = nixpkgs-unstable.legacyPackages.${system}.mihomo;
        metacubexd = nixpkgs-unstable.legacyPackages.${system}.metacubexd;
        zed-editor = nixpkgs-unstable.legacyPackages.${system}.zed-editor;
      };

      commonModules = [
        ./system/configuration.nix
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ overlay-unstable-tools ];
          environment.systemPackages = [
            treesnap.packages.${pkgs.system}.default
          ];
        })
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.Traversal = import ./home;
          home-manager.extraSpecialArgs = {
            inherit zen-browser;
            inherit system;
            inherit rime-ice;
          };
        }
      ];
    in {
      nixosConfigurations = {
        lab = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit zen-browser; };
          modules = [
            ./hosts/lab/hardware-configuration.nix
            { networking.hostName = "lab"; }
          ] ++ commonModules;
        };

        panasonic = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit zen-browser; };
          modules = [
            ./hosts/panasonic/hardware-configuration.nix
            { networking.hostName = "panasonic"; }
          ] ++ commonModules;
        };

        gpdmax2 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit zen-browser; };
          modules = [
            ./hosts/gpdmax2/hardware-configuration.nix
            { networking.hostName = "gpdmax2"; }
          ] ++ commonModules;
        };
      };
    };
}

```

