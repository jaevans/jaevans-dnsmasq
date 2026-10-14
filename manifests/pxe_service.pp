# @summary A PXE boot menu entry (`pxe-service`).
#
# @example
#   dnsmasq::pxe_service { 'bios pxelinux':
#     csa       => 'x86PC',
#     menu_text => 'PXE Boot (BIOS)',
#     basename  => 'bios/lpxelinux',
#     server    => '192.0.2.9',
#     tag       => 'pxe',
#   }
#
# @param csa
#   The client system type, e.g. `x86PC`, `x86-64_EFI`, or a number.
# @param menu_text
#   The menu entry text. Quoted, so it may contain commas.
# @param basename
#   The boot file to download by TFTP. PXE appends the layer suffix (`.0`) unless the name has an extension.
# @param boot_service_type
#   A boot service type to search the network for, instead of `basename`.
# @param server
#   The TFTP or boot server address or name. Requires `basename` or `boot_service_type`.
# @param tags
#   Only offer to clients with these tags.
# @param order
#   The position within `50-pxe-service.conf`.
define dnsmasq::pxe_service (
  Variant[String[1], Integer[0]] $csa,
  String[1] $menu_text,
  Optional[String[1]] $basename = undef,
  Optional[Integer[0]] $boot_service_type = undef,
  Optional[String[1]] $server = undef,
  Dnsmasq::TagMatches $tags = [],
  Dnsmasq::Order $order = 50,
) {
  if $basename and $boot_service_type =~ NotUndef {
    fail("dnsmasq::pxe_service[${title}]: set basename or boot_service_type, not both")
  }
  if $server and !$basename and $boot_service_type =~ Undef {
    fail("dnsmasq::pxe_service[${title}]: server requires basename or boot_service_type")
  }

  $boot = $basename ? { undef => $boot_service_type, default => $basename }

  dnsmasq::fragment { "pxe-service ${title}":
    file    => 'pxe-service',
    content => dnsmasq::line('pxe-service', [dnsmasq::tags($tags), $csa, dnsmasq::quote($menu_text), $boot, $server]),
    order   => $order,
  }
}
