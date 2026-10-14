# @summary A hardware address for `dhcp-host`, optionally prefixed with an ARP type and allowing `*` wildcards.
type Dnsmasq::Hwaddr = Pattern[/\A([0-9]+-)?[0-9A-Fa-f*]{1,2}([:-][0-9A-Fa-f*]{1,2}){5,19}\z/]
