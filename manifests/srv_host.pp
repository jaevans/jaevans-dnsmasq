# @summary An SRV record (`srv-host`).
#
# @example
#   dnsmasq::srv_host { '_ldap._tcp.example.com':
#     target   => 'ldap.example.com',
#     port     => 389,
#     priority => 10,
#     weight   => 100,
#   }
#
# @param service
#   The record name, `_<service>._<protocol>.<domain>`.
# @param target
#   The host providing the service. Without it the record says the service is not available.
# @param port
#   The service port.
# @param priority
#   The record priority. Requires `port`.
# @param weight
#   The record weight. Requires `priority`.
# @param order
#   The position within `50-srv-host.conf`.
define dnsmasq::srv_host (
  Pattern[/\A_[^\s,\/]+\._[^\s,\/]+/] $service = $title,
  Optional[Dnsmasq::Name] $target = undef,
  Optional[Stdlib::Port] $port = undef,
  Optional[Integer[0, 65535]] $priority = undef,
  Optional[Integer[0, 65535]] $weight = undef,
  Dnsmasq::Order $order = 50,
) {
  if ($port =~ NotUndef and $target =~ Undef) or ($priority =~ NotUndef and $port =~ Undef) or ($weight =~ NotUndef and $priority =~ Undef) {
    fail("dnsmasq::srv_host[${title}]: weight requires priority, priority requires port, and port requires target")
  }

  dnsmasq::fragment { "srv-host ${title}":
    file    => 'srv-host',
    content => dnsmasq::line('srv-host', [$service, $target, $port, $priority, $weight]),
    order   => $order,
  }
}
