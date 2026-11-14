# Languages, IDEs, containers and network analysis.
{ ... }:
{
  imports = [
    ./coding.nix
    ./docker.nix
    ./mkcert
    ./rust.nix
    ./virtualisation.nix
    ./wireshark.nix
  ];
}
