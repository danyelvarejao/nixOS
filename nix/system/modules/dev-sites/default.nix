# https://<name>.test → devenv's proxy (process.proxy) as <name>.localhost, with the original
# name in X-Dev-Host. *.test resolves to a dummy interface, so the Android emulator reaches it.
#
# New machine: Caddy stays off until the CA key, which is not in the repo, is in place:
#   sudo install -D -o caddy -g caddy -m 600 rootCA-key.pem /var/lib/caddy/mkcert/rootCA-key.pem
#   sudo systemctl start caddy
#
# Android emulator: install ../mkcert/rootCA.pem as a CA certificate (Settings > Security >
# Encryption & credentials), and have the app's debug build trust user CAs with
# <debug-overrides><trust-anchors><certificates src="user"/> in network_security_config.xml.
{ ... }:
let
  address = "10.254.254.1";
  devenvProxy = "127.0.0.1:7080";
  caKey = "/var/lib/caddy/mkcert/rootCA-key.pem";
in
{
  services.caddy = {
    enable = true;
    globalConfig = ''
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
          # mkcert's CA has pathlen:0: it must sign the certificates itself.
          intermediate {
            format pem_file
            cert ${../mkcert/rootCA.pem}
            key ${caKey}
          }
        }
      }
    '';
    # A * matches a single label, hence the alias for names like pma.example.test.
    virtualHosts."*.test".serverAliases = [ "*.*.test" ];
    virtualHosts."*.test".extraConfig = ''
      tls {
        on_demand
      }
      map {host} {dev_localhost} {
        ~^(.+)\.test$ "''${1}.localhost"
      }
      reverse_proxy ${devenvProxy} {
        header_up Host {dev_localhost}
        header_up X-Dev-Host {host}
      }
    '';
  };

  # Without the CA key Caddy is skipped instead of failing every switch.
  systemd.services.caddy.unitConfig.ConditionPathExists = caKey;

  environment.sessionVariables.DEVENV_PROXY_LISTEN = devenvProxy;

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
