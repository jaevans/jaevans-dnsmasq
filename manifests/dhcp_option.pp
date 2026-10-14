# @summary A DHCP option sent to clients (`dhcp-option` or `dhcp-option-force`).
#
# @example Per-network router, selected by the tag set on a dhcp_range
#   dnsmasq::dhcp_option { 'home router': option => 'router', value => '192.0.2.1', tags => 'home' }
#
# @param option
#   The option: a number, a bare name such as `router` (written as `option:router`),
#   or a name with an `option:`, `option6:` or `vi-encap:` prefix.
# @param value
#   The option value. An array is joined with commas.
# @param tags
#   Only send to clients with these tags.
# @param encap
#   Encapsulate within this option number.
# @param vi_encap
#   Encapsulate as vendor-identifying vendor-specific information for this enterprise number.
# @param vendor
#   Send as vendor-specific information to clients with this vendor class. An empty string matches any.
# @param force
#   Send the option even when the client does not request it.
# @param order
#   The position within `50-dhcp-option.conf`.
define dnsmasq::dhcp_option (
  Dnsmasq::DhcpOptionName $option,
  Optional[Variant[String, Integer, Array[Variant[String, Integer]]]] $value = undef,
  Dnsmasq::TagMatches $tags = [],
  Optional[Integer[0, 255]] $encap = undef,
  Optional[Integer[0]] $vi_encap = undef,
  Optional[String] $vendor = undef,
  Boolean $force = false,
  Dnsmasq::Order $order = 50,
) {
  $key = $force ? { true => 'dhcp-option-force', default => 'dhcp-option' }
  $fields = [
    dnsmasq::tags($tags),
    $encap ? { undef => undef, default => "encap:${encap}" },
    $vi_encap ? { undef => undef, default => "vi-encap:${vi_encap}" },
    $vendor ? { undef => undef, default => "vendor:${vendor}" },
    dnsmasq::dhcp_option_name($option),
    $value,
  ].flatten.filter |$f| { $f =~ NotUndef }

  dnsmasq::fragment { "dhcp-option ${title}":
    file    => 'dhcp-option',
    content => dnsmasq::line($key, $fields),
    order   => $order,
  }
}
