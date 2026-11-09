{ inputs, ... }:
{
  # Custom packages from the 'pkgs' directory.
  additions = final: _prev: import ../pkgs final.pkgs;

  # Version overrides and patches for packages from nixpkgs.
  modifications = final: prev: {
    # Remove once nixpkgs ships a release newer than ashell 0.11.0.
    ashell = prev.ashell.overrideAttrs (
      old:
      let
        # 0.11.0 can't read workspaces from Hyprland 0.57; fixed by upstream PR #1108.
        src = final.fetchFromGitHub {
          owner = "MalpenZibo";
          repo = "ashell";
          rev = "9bdc738d46d985b4c9b6ae63da4b9ac7cd423545";
          hash = "sha256-mmbFGPwdlnb388wHJvf5x+67WA1BlNeKF+k8XzdLnNs=";
        };
      in
      {
        version = "0.11.0-unstable-2026-11-02";
        inherit src;
        cargoDeps = final.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-mTzRaUQVApH3cZT+V8Dty0nPWnVWG8iuRM61zYewgys=";
        };

        # The build fails with AWS_LC_SYS_USE_SYSTEM=1 and no usable system
        # AWS-LC, so build the crate's bundled copy.
        nativeBuildInputs = old.nativeBuildInputs ++ [
          final.cmake
          final.perl
        ];
        dontUseCmakeConfigure = true;
        preBuild = (old.preBuild or "") + "unset AWS_LC_SYS_USE_SYSTEM; export AWS_LC_SYS_USE_SYSTEM=0\n";
      }
    );
  };
}
