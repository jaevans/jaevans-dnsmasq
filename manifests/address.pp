# @summary Answer every name under some domains locally (`address`).
#
# Without `ip`, the domains are local-only and answer NXDOMAIN for unknown names.
#
# @example Return NXDOMAIN for unknown names in example.com instead of forwarding
#   dnsmasq::address { 'example.com': }
# @example Return a fixed address for a domain and all its subdomains
#   dnsmasq::address { 'ads.example.net': ip => '0.0.0.0' }
#
# @param domains
#   The domains. `#` matches every domain.
# @param ip
#   The address to answer with, or `#` for the null address in both families.
# @param order
#   The position within `50-address.conf`.
define dnsmasq::address (
  Variant[Dnsmasq::Name, Array[Dnsmasq::Name, 1]] $domains = $title,
  Optional[Variant[Stdlib::IP::Address::Nosubnet, Enum['#']]] $ip = undef,
  Dnsmasq::Order $order = 50,
) {
  $domain_list = Array($domains, true).join('/')

  dnsmasq::fragment { "address ${title}":
    file    => 'address',
    content => dnsmasq::line('address', ["/${domain_list}/${ip}"]),
    order   => $order,
  }
}
