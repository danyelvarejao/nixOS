{ config, lib, ... }:
{
  programs.zsh =
    let
      settings = # sh
        ''
          # Load private configuration kept out of Git.
          [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

          # Unbind ^S and ^Q so the terminal doesn't freeze.
          stty -ixon

          # Directories searched by cd.
          CDPATH=$HOME:..

          # https://github.com/junegunn/fzf?tab=readme-ov-file#settings
          FZF_COMPLETION_TRIGGER='..'

          # Use fd for listing path candidates.
          _fzf_compgen_path() { fd --hidden --follow --exclude ".git" . "$1" }

          # Use fd to generate the list for directory completion.
          _fzf_compgen_dir() { fd --type d --hidden --follow --exclude ".git" . "$1" }

          # Allow command line editing in an external editor.
          autoload -Uz edit-command-line
          zle -N edit-command-line
        '';

      completion = # sh
        ''
          # Case-insensitive completion.
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

          # Complete sudo commands.
          zstyle ':completion::complete:*' gain-privileges 1
        '';

      # Keys /etc/zinputrc leaves unbound or binds differently.
      keybindings = # sh
        ''
          bindkey -- "''${terminfo[kcuu1]}" history-search-backward
          bindkey -- "''${terminfo[kcud1]}" history-search-forward
          bindkey -- "''${terminfo[kcbt]}"  reverse-menu-complete
          bindkey -- "''${terminfo[kLFT5]}" backward-word # Ctrl+Left
          bindkey -- "''${terminfo[kRIT5]}" forward-word  # Ctrl+Right
          bindkey -- "''${terminfo[kLFT3]}" backward-word # Alt+Left
          bindkey -- "''${terminfo[kRIT3]}" forward-word  # Alt+Right
          bindkey '^H'      backward-kill-word            # Ctrl+Backspace
          bindkey '^[[3;5~' kill-word                     # Ctrl+Delete
        '';

      functions = # sh
        ''
          function psg() { ps aux | grep $* }
          function take() { mkdir -p $1; cd $1 }
          # Get a 16 chars password: generate-password 16
          function generate-password() { strings /dev/urandom | grep -o '[[:alnum:]]' | head -n $1 | tr -d '\n'; echo }
          function where-from() { readlink -f $(which $1) }
          function url-sha256() { curl -sL $1 | sha256sum | cut -d ' ' -f 1 | xxd -r -p | base64 }
          function c() { printf "%s\n" "$@" | bc -l; }
        '';
    in
    {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        strategy = [
          "history"
          "completion"
        ];
      };
      syntaxHighlighting.enable = true;
      autocd = true;
      history = {
        expireDuplicatesFirst = true;
        path = "${config.xdg.dataHome}/zsh_history";
        size = 100000;
        save = 100000;
      };
      initContent = lib.mkMerge [
        (lib.mkOrder 550 (settings + functions))
        (lib.mkOrder 1000 (completion + keybindings))
      ];
      shellAliases = {
        "nswitch" = "nh os switch";
        "ntry" = "nh os test";
        "ndry" = "nh os test --dry";
        "nup" = "nh os switch --update";
        "ndev" = "nix develop --command zsh";
        "su" = "systemctl --user";
        "sr" = "sudo systemctl";
        "ju" = "journalctl --user -u";
        "jr" = "sudo journalctl -u";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        # Propagate user config
        "_" = "sudo -E";
        "ls" = "eza -lh";
        "lsa" = "ls -a";
        "lt" = "eza --tree --level=2 --long --git";
        "lta" = "lt -a";
        "l" = "ls -la";
        "h" = "history";
        "man" = "batman";
        "cat" = "bat --paging=never";
        "claudey" = "claude --permission-mode=plan --allow-dangerously-skip-permissions";
        "v" = "nvim";
        # devenv
        "d" = "devenv";
        "dr" = "devenv tasks run";
        "ds" = "devenv shell";
        "dp" = "devenv processes";
        "reload" = ". $ZDOTDIR/.zshrc";
      };
    };
}
