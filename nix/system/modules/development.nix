# Languages, IDEs, containers and network analysis.
{ ... }:
{
  imports = [
    ./coding.nix
    ./docker.nix
    ./rust.nix
    ./virtualisation.nix
    ./wireshark.nix
  ];
}
