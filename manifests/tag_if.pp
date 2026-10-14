# @summary Set tags when all of another set of tags match (`tag-if`).
#
# `tag-if` lines run in file order, so use `order` when one depends on another.
#
# @example
#   dnsmasq::tag_if { 'ipxe-ok efi': set => 'ipxe-ok', tags => ['ipxe-http', 'ipxe-menu', 'ipxe-efi'] }
#
# @param set
#   The tags to set.
# @param tags
#   The tags that must all match. Without any, `set` is applied unconditionally.
# @param order
#   The position within `50-tag-if.conf`.
define dnsmasq::tag_if (
  Variant[Dnsmasq::Tag, Array[Dnsmasq::Tag, 1]] $set,
  Dnsmasq::TagMatches $tags = [],
  Dnsmasq::Order $order = 50,
) {
  dnsmasq::fragment { "tag-if ${title}":
    file    => 'tag-if',
    content => dnsmasq::line('tag-if', dnsmasq::tags(undef, $set) + dnsmasq::tags($tags)),
    order   => $order,
  }
}
