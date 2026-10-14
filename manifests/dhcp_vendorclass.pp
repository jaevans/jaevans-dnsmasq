# @summary Set a tag from the client's vendor class (`dhcp-vendorclass`).
#
# @example
#   dnsmasq::dhcp_vendorclass { 'pxe': vendor_class => 'PXEClient' }
#
# @param vendor_class
#   The vendor class prefix to match.
# @param enterprise
#   IPv6 only: the IANA enterprise number.
# @param set
#   The tag to set.
# @param order
#   The position within `50-dhcp-vendorclass.conf`.
define dnsmasq::dhcp_vendorclass (
  String[1] $vendor_class,
  Optional[Integer[0]] $enterprise = undef,
  Dnsmasq::Tag $set = $title,
  Dnsmasq::Order $order = 50,
) {
  $enterprise_field = $enterprise ? { undef => undef, default => "enterprise:${enterprise}" }

  dnsmasq::fragment { "dhcp-vendorclass ${title}":
    file    => 'dhcp-vendorclass',
    content => dnsmasq::line('dhcp-vendorclass', [dnsmasq::tags(undef, $set), $enterprise_field, $vendor_class].flatten.filter |$f| { $f =~ NotUndef }),
    order   => $order,
  }
}
