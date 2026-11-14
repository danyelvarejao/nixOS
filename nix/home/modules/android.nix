# Android and Flutter SDKs live in $HOME and update themselves: the Android SDK through Android Studio's
# SDK Manager, Flutter through `flutter upgrade`. The nixpkgs Flutter sits in the read-only store, and
# Gradle can't build Android apps from there. Their prebuilt binaries run through nix-ld.
# Flutter, once: git clone -b stable https://github.com/flutter/flutter.git ~/.local/share/flutter
{ config, ... }:
let
  androidHome = "${config.home.homeDirectory}/Android/Sdk";
in
{
  home.sessionVariables = {
    ANDROID_HOME = androidHome;
    ANDROID_SDK_ROOT = androidHome;
  };

  home.sessionPath = [
    "$HOME/.local/share/flutter/bin"
    "${androidHome}/platform-tools"
    "${androidHome}/cmdline-tools/latest/bin"
    "${androidHome}/emulator"
  ];
}
