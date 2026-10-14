# @summary A TXT record (`txt-record`).
#
# @example
#   dnsmasq::txt_record { 'example.com': text => 'v=spf1 mx -all' }
#
# @param text
#   The record strings. Each is quoted, so it may contain commas.
# @param record_name
#   The name the record is for.
# @param order
#   The position within `50-txt-record.conf`.
define dnsmasq::txt_record (
  Variant[String, Array[String, 1]] $text,
  Dnsmasq::Name $record_name = $title,
  Dnsmasq::Order $order = 50,
) {
  dnsmasq::fragment { "txt-record ${title}":
    file    => 'txt-record',
    content => dnsmasq::line('txt-record', [$record_name, [$text].flatten.map |$t| { dnsmasq::quote($t) }]),
    order   => $order,
  }
}
