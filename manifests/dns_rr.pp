# @summary An arbitrary resource record given as hex data (`dns-rr`).
#
# @example An SSHFP record
#   dnsmasq::dns_rr { 'host.example.com': rr_type => 44, data => '01:01:...' }
#
# @param rr_type
#   The RR type number.
# @param data
#   The record data as hex bytes, optionally separated by colons.
# @param record_name
#   The name the record is for.
# @param order
#   The position within `50-dns-rr.conf`.
define dnsmasq::dns_rr (
  Integer[1, 65535] $rr_type,
  Optional[Pattern[/\A[0-9A-Fa-f]{2}(:?[0-9A-Fa-f]{2})*\z/]] $data = undef,
  Dnsmasq::Name $record_name = $title,
  Dnsmasq::Order $order = 50,
) {
  dnsmasq::fragment { "dns-rr ${title}":
    file    => 'dns-rr',
    content => dnsmasq::line('dns-rr', [$record_name, $rr_type, $data]),
    order   => $order,
  }
}
