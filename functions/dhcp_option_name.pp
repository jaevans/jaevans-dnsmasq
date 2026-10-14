# @summary Normalise a DHCP option reference.
#
# Numbers and names already carrying an `option:`, `option6:` or `vi-encap:` prefix
# are returned unchanged; a bare name such as `router` becomes `option:router`.
#
# @param option
#   The option number or name.
#
# @return [String] The option as dnsmasq expects it.
function dnsmasq::dhcp_option_name(Dnsmasq::DhcpOptionName $option) >> String {
  $s = String($option)
  $s =~ /\A([0-9]+|option6?:.+|vi-encap:.+)\z/ ? {
    true    => $s,
    default => "option:${s}",
  }
}
