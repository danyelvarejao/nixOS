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

      # Personal settings. Change these to make the configuration yours.
      vars = {
        user = "danyel";
        fullName = "Danyel Varejao";
        git = {
          name = "danyelvarejao";
          email = "danyelvarejao@gmail.com";
        };
        # Public keys allowed to log in over SSH.
        sshKeys = [ ./danyel.pub ];
        timeZone = "America/Recife";
        locale = "en_US.UTF-8";
        # Locale used by the bar for dates.
        region = "pt-BR";
        keyboard = {
          layout = "us";
          variant = "intl";
          # A console keymap name, which can differ from the XKB layout.
          console = "us";
        };
      };

      specialArgs = { inherit inputs outputs vars; };

      mkHost =
        name:
        lib.nixosSystem {
          inherit specialArgs;
          modules = [
            { home-manager.users.${vars.user} = import ./nix/home/${name}; }
            ./nix/system/${name}
          ];
        };

      # Every nix/system/<host> with a hardware.nix is a host; the file is generated on installation.
      hosts = lib.attrNames (
        lib.filterAttrs (
          name: type: type == "directory" && builtins.pathExists ./nix/system/${name}/hardware.nix
        ) (builtins.readDir ./nix/system)
      );
    in
    {
      overlays = import ./nix/overlays { inherit inputs; };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      nixosConfigurations = lib.genAttrs hosts mkHost;
    };
}
