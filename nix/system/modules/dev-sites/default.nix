# Local HTTPS sites for development, reachable from this machine and the Android emulator.
#
# - https://<port>.test proxies to 127.0.0.1:<port>.
# - Named sites live in each project, not here: a project writes <name>.caddy into
#   /var/lib/dev-sites/ and reloads Caddy itself, with no root needed:
#     example.test {
#       import dev-site
#       reverse_proxy 127.0.0.1:8085
#     }
#     caddy reload --config /etc/caddy/caddy_config --adapter caddyfile
#   A file Caddy rejects fails the reload and leaves the running sites alone, but it also
#   keeps Caddy from starting on the next boot until it is fixed or removed.
# - Certificates are signed on first use by the shared mkcert CA (../mkcert).
# - *.test resolves (NetworkManager's dnsmasq) to `address`, held by a dummy interface so it
#   exists with or without a network, and the emulator, which uses the host's DNS, reaches it.
#
# New machine: Caddy stays off until the CA key, which is not in the repo, is in place:
#   sudo install -D -o caddy -g caddy -m 600 rootCA-key.pem /var/lib/caddy/mkcert/rootCA-key.pem
#   sudo systemctl start caddy
#
# Android emulator: install ../mkcert/rootCA.pem as a CA certificate (Settings > Security >
# Encryption & credentials), and have the app's debug build trust user CAs with
# <debug-overrides><trust-anchors><certificates src="user"/> in network_security_config.xml.
{ vars, ... }:
let
  address = "10.254.254.1";
  sitesDir = "/var/lib/dev-sites";
  caKey = "/var/lib/caddy/mkcert/rootCA-key.pem";
in
{
  services.caddy = {
    enable = true;
    globalConfig = ''
      # HTTPS only: port 80 stays free for projects that serve plain HTTP behind this Caddy
      # (an nginx with production's config, for instance).
      auto_https disable_redirects
      local_certs
      skip_install_trust
      pki {
        ca local {
          root {
            format pem_file
            cert ${../mkcert/rootCA.pem}
            key ${caKey}
          }
          # mkcert's CA has pathlen:0, so it must sign the certificates itself, not through
          # an intermediate of Caddy's.
          intermediate {
            format pem_file
            cert ${../mkcert/rootCA.pem}
            key ${caKey}
          }
        }
      }
    '';
    # Every .test site issues its certificate on its first request: *.test catches every name,
    # and a *.test wildcard certificate is rejected by most clients. No `ask` endpoint: only
    # this machine reaches Caddy.
    extraConfig = ''
      (dev-site) {
        tls {
          on_demand
        }
      }

      import ${sitesDir}/*.caddy
    '';
    virtualHosts."*.test".extraConfig = ''
      import dev-site
      reverse_proxy 127.0.0.1:{labels.1}
    '';
  };

  # Without the CA key Caddy is skipped instead of failing every switch (see the top).
  systemd.services.caddy.unitConfig.ConditionPathExists = caKey;

  systemd.tmpfiles.rules = [ "d ${sitesDir} 0755 ${vars.user} users -" ];

  # The address *.test points at, on a dummy interface so it is always up.
  networking.networkmanager.ensureProfiles.profiles.dev-sites = {
    connection = {
      id = "dev-sites";
      type = "dummy";
      interface-name = "devsites0";
      autoconnect = true;
    };
    ipv4 = {
      method = "manual";
      address1 = "${address}/32";
    };
  };

  networking.networkmanager.dns = "dnsmasq";
  environment.etc."NetworkManager/dnsmasq.d/dev-sites.conf".text = ''
    address=/test/${address}
  '';
  # dnsmasq (127.0.0.1) goes before networking.nameservers in resolv.conf.
  networking.resolvconf.useLocalResolver = true;
}
