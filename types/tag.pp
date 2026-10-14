# @summary A dnsmasq tag name, as used with `set:`.
type Dnsmasq::Tag = Pattern[/\A[^\s,:!]+\z/]
