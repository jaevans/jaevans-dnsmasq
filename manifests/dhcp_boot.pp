# @summary The BOOTP filename and server to give DHCP clients (`dhcp-boot`).
#
# @example Chain-load an iPXE menu once the client is running iPXE
#   dnsmasq::dhcp_boot { 'ipxe menu': filename => 'menu.ipxe', server_address => '192.0.2.9', tags => 'ipxe-ok' }
#
# @param filename
#   The boot file.
# @param server_name
#   The boot server name.
# @param server_address
#   The boot (TFTP) server address or name.
# @param tags
#   Only send to clients with these tags.
# @param order
#   The position within `50-dhcp-boot.conf`. The first matching line wins.
define dnsmasq::dhcp_boot (
  String[1] $filename,
  Optional[String[1]] $server_name = undef,
  Optional[String[1]] $server_address = undef,
  Dnsmasq::TagMatches $tags = [],
  Dnsmasq::Order $order = 50,
) {
  dnsmasq::fragment { "dhcp-boot ${title}":
    file    => 'dhcp-boot',
    content => dnsmasq::line('dhcp-boot', [dnsmasq::tags($tags), $filename, $server_name, $server_address]),
    order   => $order,
  }
}
