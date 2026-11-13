{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Languages and build tools
    bun
    (lib.setPrio 11 clang) # gcc and clang both ship cc at priority 10; gcc wins
    cmake
    gcc
    gnumake
    go
    http-server
    llvm
    ninja
    nodejs
    openssl
    pnpm
    python3
    ruby
    uv

    # CI and tunnels
    act # run GitHub Actions locally
    cloudflared

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

    # Profilers
    heaptrack
    tracy

    # AI coding agents
    claude-code
  ];

  # Claude Code system-wide settings: no Co-Authored-By trailer, PR footer or session link.
  # Managed settings sit above ~/.claude/settings.json, which Claude Code keeps writable for itself.
  environment.etc."claude-code/managed-settings.json".text = builtins.toJSON {
    attribution = {
      commit = "";
      pr = "";
      sessionUrl = false;
    };
  };

  # Safety net for prebuilt binaries that expect a standard Linux layout.
  programs.nix-ld.enable = true;
}
