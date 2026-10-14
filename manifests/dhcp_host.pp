# @summary A DHCP host reservation or per-host setting (`dhcp-host`).
#
# @example
#   dnsmasq::dhcp_host { 'printer': mac => '00:11:22:33:44:55', ip => '192.0.2.40' }
#
# @param mac
#   Hardware addresses that match this host.
# @param client_id
#   A client identifier to match, or `*` to ignore the client ID.
# @param ip
#   Addresses to give the host. IPv6 addresses are bracketed automatically.
# @param hostname
#   The hostname to give the host. Defaults to the title; `false` omits it.
# @param lease_time
#   The lease time for this host.
# @param tags
#   Only apply to clients with these tags.
# @param set
#   Set this tag on the host.
# @param ignore
#   Ignore DHCP requests from this host.
# @param order
#   The position within `50-dhcp-host.conf`.
define dnsmasq::dhcp_host (
  Variant[Dnsmasq::Hwaddr, Array[Dnsmasq::Hwaddr]] $mac = [],
  Optional[String[1]] $client_id = undef,
  Variant[Stdlib::IP::Address::Nosubnet, Array[Stdlib::IP::Address::Nosubnet]] $ip = [],
  Variant[Dnsmasq::Name, Boolean[false]] $hostname = $title,
  Optional[Dnsmasq::LeaseTime] $lease_time = undef,
  Dnsmasq::TagMatches $tags = [],
  Optional[Dnsmasq::Tag] $set = undef,
  Boolean $ignore = false,
  Dnsmasq::Order $order = 50,
) {
  $client = $client_id ? { undef => undef, default => "id:${client_id}" }
  $addresses = [$ip].flatten.map |$a| {
    $a ? { Stdlib::IP::Address::V6 => "[${a}]", default => $a }
  }
  $host_name = $hostname ? { false => undef, default => $hostname }
  $ignore_field = $ignore ? { true => 'ignore', default => undef }

  $fields = [
    [$mac].flatten,
    $client,
    dnsmasq::tags(undef, $set),
    dnsmasq::tags($tags),
    $addresses,
    $host_name,
    $lease_time,
    $ignore_field,
  ].flatten.filter |$f| { $f =~ NotUndef }

  dnsmasq::fragment { "dhcp-host ${title}":
    file    => 'dhcp-host',
    content => dnsmasq::line('dhcp-host', $fields),
    order   => $order,
  }
}
