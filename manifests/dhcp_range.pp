# @summary A DHCP address range (`dhcp-range`), IPv4 or IPv6 according to `start`.
#
# @example IPv4 range tagged for per-network options
#   dnsmasq::dhcp_range { 'home':
#     start      => '192.0.2.50',
#     end        => '192.0.2.99',
#     netmask    => '255.255.255.0',
#     lease_time => '2d',
#     set        => 'home',
#   }
# @example IPv6 SLAAC with names, addresses taken from an interface
#   dnsmasq::dhcp_range { 'home6':
#     start       => '::',
#     constructor => 'eth0',
#     modes       => ['ra-names'],
#     prefix_length => 64,
#     lease_time  => '24h',
#   }
#
# @param start
#   The first address, or the network address with `modes` such as `static` or `proxy`.
# @param end
#   The last address.
# @param constructor
#   IPv6 only: build the range from this interface's prefix. Replaces `end`.
# @param modes
#   Mode keywords such as `static`, `proxy`, `ra-only`, `ra-names`, `ra-stateless`, `slaac`.
# @param netmask
#   IPv4 only: the netmask, needed when the range is not on a local interface.
# @param broadcast
#   IPv4 only: the broadcast address. Requires `netmask`.
# @param prefix_length
#   IPv6 only: the prefix length.
# @param lease_time
#   The lease time.
# @param tags
#   Only use this range for clients with these tags.
# @param set
#   Set this tag on clients served from this range.
# @param order
#   The position within `50-dhcp-range.conf`.
define dnsmasq::dhcp_range (
  Stdlib::IP::Address::Nosubnet $start,
  Optional[Stdlib::IP::Address::Nosubnet] $end = undef,
  Optional[String[1]] $constructor = undef,
  Array[Pattern[/\A[a-z-]+\z/]] $modes = [],
  Optional[Stdlib::IP::Address::V4::Nosubnet] $netmask = undef,
  Optional[Stdlib::IP::Address::V4::Nosubnet] $broadcast = undef,
  Optional[Integer[1, 128]] $prefix_length = undef,
  Optional[Dnsmasq::LeaseTime] $lease_time = undef,
  Dnsmasq::TagMatches $tags = [],
  Optional[Dnsmasq::Tag] $set = undef,
  Dnsmasq::Order $order = 50,
) {
  if $start =~ Stdlib::IP::Address::V4 {
    if $constructor or $prefix_length {
      fail("dnsmasq::dhcp_range[${title}]: constructor and prefix_length are IPv6 only")
    }
    if $broadcast and !$netmask {
      fail("dnsmasq::dhcp_range[${title}]: broadcast requires netmask")
    }
    $fields = [$end, $modes, $netmask, $broadcast, $lease_time]
  } else {
    if $netmask or $broadcast {
      fail("dnsmasq::dhcp_range[${title}]: netmask and broadcast are IPv4 only")
    }
    if $end and $constructor {
      fail("dnsmasq::dhcp_range[${title}]: set end or constructor, not both")
    }
    # dnsmasq reads a bare number after the modes as the prefix length.
    if $lease_time =~ Integer and !$prefix_length {
      fail("dnsmasq::dhcp_range[${title}]: an integer lease_time on an IPv6 range requires prefix_length")
    }
    $range_end = $constructor ? { undef => $end, default => "constructor:${constructor}" }
    $fields = [$range_end, $modes, $prefix_length, $lease_time]
  }

  dnsmasq::fragment { "dhcp-range ${title}":
    file    => 'dhcp-range',
    content => dnsmasq::line('dhcp-range', [dnsmasq::tags($tags, $set), $start, $fields.flatten.filter |$f| { $f =~ NotUndef }]),
    order   => $order,
  }
}
