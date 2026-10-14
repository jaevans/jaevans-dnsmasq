# @summary Render one dnsmasq configuration line.
#
# Fields are flattened and joined with commas. Trailing `undef` fields are dropped;
# `undef` fields followed by a defined field render as empty, which dnsmasq treats
# as "not given" for positional arguments such as the server name in `dhcp-boot`.
#
# @param option
#   The dnsmasq long option name, without leading dashes.
# @param fields
#   The comma-separated values for the option.
#
# @return [String] The option line, terminated by a newline.
#
# @example
#   dnsmasq::line('dhcp-boot', ['menu.ipxe', undef, '192.0.2.1']) # => "dhcp-boot=menu.ipxe,,192.0.2.1\n"
function dnsmasq::line(Dnsmasq::OptionName $option, Array $fields = []) >> String {
  $flat = $fields.flatten
  $last = $flat.reverse.index |$f| { $f =~ NotUndef }
  $kept = $last ? {
    undef   => [],
    default => $flat[0, $flat.length - $last],
  }
  $value = $kept.map |$f| { $f ? { undef => '', default => String($f) } }.join(',')
  $value ? {
    ''      => "${option}\n",
    default => "${option}=${value}\n",
  }
}
