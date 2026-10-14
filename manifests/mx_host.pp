# @summary An MX record (`mx-host`).
#
# @example
#   dnsmasq::mx_host { 'example.com': hostname => 'mail.example.com', preference => 10 }
#
# @param mx_name
#   The domain the MX record is for.
# @param hostname
#   The mail exchanger. dnsmasq defaults to the host it runs on.
# @param preference
#   The MX preference. dnsmasq defaults to 1.
# @param order
#   The position within `50-mx-host.conf`.
define dnsmasq::mx_host (
  Dnsmasq::Name $mx_name = $title,
  Optional[Dnsmasq::Name] $hostname = undef,
  Optional[Integer[0, 65535]] $preference = undef,
  Dnsmasq::Order $order = 50,
) {
  dnsmasq::fragment { "mx-host ${title}":
    file    => 'mx-host',
    content => dnsmasq::line('mx-host', [$mx_name, $hostname, $preference].filter |$f| { $f =~ NotUndef }),
    order   => $order,
  }
}
