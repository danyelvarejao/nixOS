{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Languages and build tools
    bun
    gcc
    gnumake
    go
    http-server
    luarocks
    nodejs
    openssl
    pnpm
    python3
    ruby
    stylua
    tree-sitter
    uv

    # Editors and IDEs
    android-studio
    android-tools
    jetbrains-toolbox
    vscode

    # Database and reverse engineering
    beekeeper-studio
    ghidra
    hopper
    httptoolkit

    # AI coding agents
    claude-code
  ];

  # Safety net for prebuilt binaries that expect a standard Linux layout.
  programs.nix-ld.enable = true;
}
