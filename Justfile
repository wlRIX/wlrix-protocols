#!/usr/bin/env just --justfile

# List available recipes.
default:
  @just --list

# Validate every protocol against the Wayland DTD, then run it through wayland-scanner, which
# also catches what the DTD cannot: an enum used as an argument type that is not declared, an
# interface name used twice, a `since` newer than its interface.
#
# References to interfaces from other protocols (`zwlr_output_head_v1` in
# wlrix-output-color) are not resolved here, since the C scanner treats every interface it
# does not define as external. The consumers' own builds are what check those.
check:
  #!/usr/bin/env sh
  set -eu
  dtd=/usr/share/wayland/wayland.dtd
  for protocol in *.xml; do
      xmllint --noout --dtdvalid "$dtd" "$protocol"
      wayland-scanner --strict client-header "$protocol" /dev/null
      wayland-scanner --strict private-code "$protocol" /dev/null
      echo "$protocol: valid"
  done
