# @summary An upstream DNS server, optionally for specific domains only (`server`).
#
# With `domains` and no `ip`, the domains are answered locally only. With `ip => '#'`,
# the domains use the standard upstream servers.
#
# @example Forward a domain to a specific server
#   dnsmasq::server { 'corp': domains => ['corp.example.com'], ip => '10.0.0.53' }
#
# @param ip
#   The server address, or `#` for the standard servers.
# @param domains
#   Restrict this server to these domains. An empty string matches unqualified names.
# @param port
#   The server port.
# @param interface
#   The interface to send queries from.
# @param source
#   The source address to send queries from, optionally with `#<port>`.
# @param order
#   The position within `50-server.conf`. Order matters with the `strict-order` option.
define dnsmasq::server (
  Optional[Variant[Stdlib::IP::Address::Nosubnet, Enum['#']]] $ip = undef,
  Array[Variant[Dnsmasq::Name, Enum['']]] $domains = [],
  Optional[Stdlib::Port] $port = undef,
  Optional[String[1]] $interface = undef,
  Optional[String[1]] $source = undef,
  Dnsmasq::Order $order = 50,
) {
  if $ip =~ Undef and $domains.empty {
    fail("dnsmasq::server[${title}]: set ip, domains, or both")
  }

  $domain_part = $domains.empty ? {
    true    => '',
    default => "/${domains.join('/')}/",
  }
  $port_part = $port ? { undef => '', default => "#${port}" }
  $interface_part = $interface ? { undef => '', default => "@${interface}" }
  $source_part = $source ? { undef => '', default => "@${source}" }

  dnsmasq::fragment { "server ${title}":
    file    => 'server',
    content => dnsmasq::line('server', ["${domain_part}${ip}${port_part}${interface_part}${source_part}"]),
    order   => $order,
  }
}
