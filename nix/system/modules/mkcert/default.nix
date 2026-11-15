# Local HTTPS for development: one mkcert CA shared by every host.
#
# rootCA.pem is public and lives here, since security.pki is read at build time.
# Its key is not in the repo: on a new machine, copy rootCA-key.pem from another one
# into ~/.local/share/mkcert/ (mkcert's default CAROOT), next to a copy of rootCA.pem.
{ ... }:
{
  # System bundle: curl, OpenSSL, Go, and Firefox, Chromium and Chrome through NixOS's NSS.
  security.pki.certificateFiles = [ ./rootCA.pem ];

  # Node ships its own CA list and ignores the system bundle.
  environment.variables.NODE_EXTRA_CA_CERTS = "${./rootCA.pem}";
}
