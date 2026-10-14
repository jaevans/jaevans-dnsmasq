# @summary A PTR record (`ptr-record`).
#
# @example
#   dnsmasq::ptr_record { '_http._tcp.dns-sd-services': target => '"New Office"._http._tcp.dns-sd-services' }
#
# @param ptr_name
#   The name the record is for.
# @param target
#   The name the record points to.
# @param order
#   The position within `50-ptr-record.conf`.
define dnsmasq::ptr_record (
  String[1] $ptr_name = $title,
  Optional[String[1]] $target = undef,
  Dnsmasq::Order $order = 50,
) {
  dnsmasq::fragment { "ptr-record ${title}":
    file    => 'ptr-record',
    content => dnsmasq::line('ptr-record', [$ptr_name, $target]),
    order   => $order,
  }
}
