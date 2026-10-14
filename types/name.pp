# @summary A DNS or DHCP name as written in a dnsmasq option: no commas, slashes or whitespace.
type Dnsmasq::Name = Pattern[/\A[^\s,\/]+\z/]
