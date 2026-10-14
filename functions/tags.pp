# @summary Render the `tag:` and `set:` fields that lead many DHCP options.
#
# @param match
#   Tags to match, rendered as `tag:<name>`.
# @param set
#   Tags to set, rendered as `set:<name>`.
#
# @return [Array[String]] The fields, match tags first.
function dnsmasq::tags(
  Variant[Dnsmasq::TagMatches, Undef] $match = [],
  Variant[Dnsmasq::Tag, Array[Dnsmasq::Tag], Undef] $set = [],
) >> Array[String] {
  $match_tags = Array($match, true).filter |$t| { $t =~ NotUndef }
  $set_tags = Array($set, true).filter |$t| { $t =~ NotUndef }
  $match_tags.map |$t| { "tag:${t}" } + $set_tags.map |$t| { "set:${t}" }
}
