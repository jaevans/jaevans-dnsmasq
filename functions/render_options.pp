# @summary Render the `dnsmasq::options` hash as configuration lines, in hash order.
#
# @param options
#   Option names mapped to values. `true` writes a bare flag, `false` omits the
#   option, and an array writes the option once per element.
#
# @return [String] The rendered lines.
function dnsmasq::render_options(Hash[Dnsmasq::OptionName, Dnsmasq::OptionValue] $options) >> String {
  $options.map |$name, $value| {
    $value ? {
      true    => dnsmasq::line($name),
      false   => '',
      Array   => $value.map |$v| { dnsmasq::line($name, [$v]) }.join,
      default => dnsmasq::line($name, [$value]),
    }
  }.join
}
