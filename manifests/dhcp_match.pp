# @summary Set a tag when a client sends a DHCP option (`dhcp-match`).
#
# @example Tag iPXE clients that support HTTP
#   dnsmasq::dhcp_match { 'ipxe-http': option => 175, value => 19 }
#
# @param option
#   The option: a number, a bare name such as `client-arch` (written as `option:client-arch`),
#   or a name with an `option:`, `option6:` or `vi-encap:` prefix.
# @param value
#   Only match when the option has this value.
# @param set
#   The tag to set.
# @param order
#   The position within `50-dhcp-match.conf`.
define dnsmasq::dhcp_match (
  Dnsmasq::DhcpOptionName $option,
  Optional[Variant[String[1], Integer]] $value = undef,
  Dnsmasq::Tag $set = $title,
  Dnsmasq::Order $order = 50,
) {
  dnsmasq::fragment { "dhcp-match ${title}":
    file    => 'dhcp-match',
    content => dnsmasq::line('dhcp-match', [dnsmasq::tags(undef, $set), dnsmasq::dhcp_option_name($option), $value]),
    order   => $order,
  }
}
