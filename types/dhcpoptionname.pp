# @summary A DHCP option: a number, a bare option name, or a name prefixed with `option:`, `option6:` or `vi-encap:`.
type Dnsmasq::DhcpOptionName = Variant[Integer[0, 65535], Pattern[/\A[a-z0-9][a-z0-9:-]*\z/]]
