# @summary A CAA record (`caa-record`).
#
# @example
#   dnsmasq::caa_record { 'example.com': property => 'issue', value => 'letsencrypt.org' }
#
# @param property
#   The property tag, e.g. `issue`, `issuewild` or `iodef`.
# @param value
#   The property value. Must not contain commas.
# @param flags
#   The CAA flags; 128 marks the property critical.
# @param record_name
#   The name the record is for.
# @param order
#   The position within `50-caa-record.conf`.
define dnsmasq::caa_record (
  Pattern[/\A[A-Za-z0-9]+\z/] $property,
  Pattern[/\A[^,]+\z/] $value,
  Integer[0, 255] $flags = 0,
  Dnsmasq::Name $record_name = $title,
  Dnsmasq::Order $order = 50,
) {
  dnsmasq::fragment { "caa-record ${title}":
    file    => 'caa-record',
    content => dnsmasq::line('caa-record', [$record_name, $flags, $property, $value]),
    order   => $order,
  }
}
