# IDEs, containers and network analysis. Languages come from each project's devenv.nix.
{ ... }:
{
  imports = [
    ./coding.nix
    ./docker.nix
    ./mkcert
    ./virtualisation.nix
    ./wireshark.nix
  ];

  # Let profilers (perf, tracy, heaptrack) sample CPU events of the user's own processes; the default 2 blocks it.
  boot.kernel.sysctl."kernel.perf_event_paranoid" = 1;
}
