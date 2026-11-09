{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nil
    nix-search-cli
    nixfmt
    nixpkgs-review
  ];

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        flake-registry = "";
        trusted-users = [
          "root"
          "danyel"
        ];
        nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
        auto-optimise-store = true;
      };
      channel.enable = false;
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = config.home-manager.users.danyel.custom.dotfiles;
  };
}
