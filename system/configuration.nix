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
