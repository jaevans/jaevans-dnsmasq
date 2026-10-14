# @summary A dnsmasq long option name, without leading dashes.
type Dnsmasq::OptionName = Pattern[/\A[a-z0-9][a-z0-9-]*\z/]
