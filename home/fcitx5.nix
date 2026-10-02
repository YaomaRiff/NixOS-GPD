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
