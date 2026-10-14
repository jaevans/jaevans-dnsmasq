# @summary A value in the `dnsmasq::options` hash.
#
# `true` writes the bare option, `false` omits it, an array writes the option once per element.
type Dnsmasq::OptionValue = Variant[Boolean, String, Integer, Array[Variant[String, Integer]]]
