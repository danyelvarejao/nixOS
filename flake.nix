{
  description = "Danyel's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Not in nixpkgs. Built by nix/pkgs/omasnap.nix.
    omasnap = {
      url = "github:omacom/omasnap";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;
      specialArgs = { inherit inputs outputs; };

      mkHost =
        name:
        lib.nixosSystem {
          inherit specialArgs;
          modules = [
            { home-manager.users.danyel = import ./nix/home/${name}; }
            ./nix/system/${name}
          ];
        };

      # A real host joins once its hardware.nix is generated during installation.
      hosts = [
        "nixos-test"
      ]
      ++ lib.optional (builtins.pathExists ./nix/system/desktop/hardware.nix) "desktop";
    in
    {
      overlays = import ./nix/overlays { inherit inputs; };
      nixosConfigurations = lib.genAttrs hosts mkHost;
    };
}
