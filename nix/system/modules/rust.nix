# Toolchains come from rustup (run `rustup default stable` once); it also provides cargo, rustc and rust-analyzer.
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cargo-watch
    rustup
  ];
}
