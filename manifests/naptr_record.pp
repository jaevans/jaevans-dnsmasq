# @summary A NAPTR record (`naptr-record`).
#
# @param naptr_order
#   The NAPTR order field. Named to avoid clashing with `order`.
# @param preference
#   The NAPTR preference field.
# @param flags
#   The NAPTR flags field.
# @param service
#   The NAPTR service field.
# @param regexp
#   The NAPTR regexp field. Must not contain commas.
# @param replacement
#   The NAPTR replacement field.
# @param record_name
#   The name the record is for.
# @param order
#   The position within `50-naptr-record.conf`.
define dnsmasq::naptr_record (
  Integer[0, 65535] $naptr_order,
  Integer[0, 65535] $preference,
  String $flags,
  String $service,
  Pattern[/\A[^,]*\z/] $regexp,
  Optional[Dnsmasq::Name] $replacement = undef,
  Dnsmasq::Name $record_name = $title,
  Dnsmasq::Order $order = 50,
) {
  dnsmasq::fragment { "naptr-record ${title}":
    file    => 'naptr-record',
    content => dnsmasq::line('naptr-record', [$record_name, $naptr_order, $preference, $flags, $service, $regexp, $replacement]),
    order   => $order,
  }
}
