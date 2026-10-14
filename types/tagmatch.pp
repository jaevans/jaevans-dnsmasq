# @summary A dnsmasq tag to match with `tag:`. A leading `!` negates the match.
type Dnsmasq::TagMatch = Pattern[/\A!?[^\s,:!]+\z/]
