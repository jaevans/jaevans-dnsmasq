# @summary A DHCP lease time: seconds, a number with an `m`, `h`, `d` or `w` suffix, or `infinite`.
type Dnsmasq::LeaseTime = Variant[Integer[120], Pattern[/\A[0-9]+[smhdw]?\z/], Enum['infinite']]
