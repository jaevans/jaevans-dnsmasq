# @summary An A/AAAA record with its PTR (`host-record`).
#
# dnsmasq accepts one IPv4 and one IPv6 address per `host-record` line, so extra
# addresses are written as further lines for the same names. Only the first line
# creates PTR records.
#
# @example
#   dnsmasq::host_record { 'router.example.com': ip => ['192.0.2.1', '2001:db8::1'] }
#
# @param names
#   The names to answer for.
# @param ip
#   The IPv4 and/or IPv6 addresses.
# @param ttl
#   The TTL for these records.
# @param order
#   The position within `50-host-record.conf`.
define dnsmasq::host_record (
  Variant[Stdlib::IP::Address::Nosubnet, Array[Stdlib::IP::Address::Nosubnet, 1]] $ip,
  Variant[Dnsmasq::Name, Array[Dnsmasq::Name, 1]] $names = $title,
  Optional[Integer[0]] $ttl = undef,
  Dnsmasq::Order $order = 50,
) {
  $ips = [$ip].flatten
  $v4 = $ips.filter |$a| { $a =~ Stdlib::IP::Address::V4 }
  $v6 = $ips.filter |$a| { $a =~ Stdlib::IP::Address::V6 }

  $content = Integer[0, max($v4.length, $v6.length) - 1].map |$i| {
    dnsmasq::line('host-record', [[$names].flatten, [$v4[$i], $v6[$i]].filter |$a| { $a =~ NotUndef }, $ttl])
  }.join

  dnsmasq::fragment { "host-record ${title}":
    file    => 'host-record',
    content => $content,
    order   => $order,
  }
}
