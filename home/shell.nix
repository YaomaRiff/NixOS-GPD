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
