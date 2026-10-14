# @summary A CNAME record (`cname`).
#
# The target must be a name dnsmasq knows locally, e.g. from `host_record` or DHCP.
#
# @example
#   dnsmasq::cname { 'www.example.com': target => 'web.example.com' }
#
# @param target
#   The canonical name.
# @param aliases
#   The alias names.
# @param ttl
#   The TTL for the record.
# @param order
#   The position within `50-cname.conf`.
define dnsmasq::cname (
  Dnsmasq::Name $target,
  Variant[Dnsmasq::Name, Array[Dnsmasq::Name, 1]] $aliases = $title,
  Optional[Integer[0]] $ttl = undef,
  Dnsmasq::Order $order = 50,
) {
  dnsmasq::fragment { "cname ${title}":
    file    => 'cname',
    content => dnsmasq::line('cname', [[$aliases].flatten, $target, $ttl]),
    order   => $order,
  }
}
