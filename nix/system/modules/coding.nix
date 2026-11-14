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

  # Claude Code system-wide settings: no Co-Authored-By trailer, PR footer or session link, plus plugins.
  # Managed settings sit above ~/.claude/settings.json, which Claude Code keeps writable for itself.
  environment.etc."claude-code/managed-settings.json".text = builtins.toJSON {
    attribution = {
      commit = "";
      pr = "";
      sessionUrl = false;
    };

    extraKnownMarketplaces = {
      mattpocock.source = {
        source = "github";
        repo = "mattpocock/skills";
      };
      rea.source = {
        source = "github";
        repo = "morluto/rea";
      };
    };

    # Installed automatically on the next launch; can't be turned off from /plugin.
    enabledPlugins = {
      "superpowers@claude-plugins-official" = true;
      "feature-dev@claude-plugins-official" = true;
      "frontend-design@claude-plugins-official" = true;
      "context7@claude-plugins-official" = true;
      "mattpocock-skills@mattpocock" = true; # includes grill-me
      "rea@rea" = true; # reverse engineering skills + MCP server; uses the installed ghidra
    };
  };

  # java on PATH and JAVA_HOME; Ghidra 12 headless (used by REA) needs JDK 25+, and the default jdk is 21.
  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };

  # Safety net for prebuilt binaries that expect a standard Linux layout.
  programs.nix-ld = {
    enable = true;

    # Libraries for prebuilt GUI apps/games (Wayland, X11, GL, Vulkan, audio, D-Bus).
    libraries = with pkgs; [
      wayland
      libxkbcommon
      libGL
      vulkan-loader
      libx11
      libxcursor
      libxi
      libxrandr
      alsa-lib
      dbus
    ];
  };
}
