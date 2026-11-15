{ lib, pkgs, ... }:
let
  # REA's MCP server runs `node` from the PATH, and its Ghidra 12 headless needs JDK 25+ (the default jdk is 21).
  # They reach Claude Code and what it runs, not the rest of the system.
  claude-code = pkgs.symlinkJoin {
    name = "claude-code";
    paths = [ pkgs.claude-code ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --prefix PATH : ${
          lib.makeBinPath [
            pkgs.nodejs
            pkgs.jdk25
          ]
        } \
        --set JAVA_HOME ${pkgs.jdk25.home}
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    # Languages and compilers come from each project's devenv.nix; outside one, `nix shell nixpkgs#go`.
    http-server
    openssl
    python3

    # CI and tunnels
    act # run GitHub Actions locally
    cloudflared

    # Editors and IDEs
    android-studio
    jetbrains-toolbox
    vscode

    # Database and reverse engineering
    beekeeper-studio
    ghidra
    hopper
    httptoolkit

    # Profilers
    heaptrack

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

      # Android emulator run outside Android Studio (e.g. by `flutter emulators --launch`).
      expat
      libbsd
      libdrm
      libice
      libpng
      libpulseaudio
      libsm
      libxcb
      libxext
      libxkbfile
      nspr
      nss
    ];
  };
}
