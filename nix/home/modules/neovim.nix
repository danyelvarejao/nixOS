# The nvim/ directory is symlinked into ~/.config/nvim so LazyVim stays editable.
{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # The init.lua comes from nvim/, linked below.
  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

  programs.neovide = {
    enable = true;
    settings = {
      tabs = false;
      fork = true;
      startup-message-capture = false; # for nvim noice
      font = {
        normal = [ config.stylix.fonts.monospace.name ];
        size = config.stylix.fonts.sizes.terminal; # Match the terminal.
      };
    };
  };

  home.packages = with pkgs; [
    gopls
    gotools # goimports
    lua-language-server
    luarocks
    marksman # Markdown
    oxfmt
    oxlint
    pyright
    ruff
    shfmt
    stylelint
    stylelint-lsp
    stylua
    taplo # TOML
    tree-sitter
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server
  ];

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.custom.dotfiles}/nvim";

  stylix.targets.neovim.enable = false;
  stylix.targets.neovide.enable = false;
}
