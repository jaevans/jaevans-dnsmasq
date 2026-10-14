# @summary Quote a string for a dnsmasq configuration file so that it may contain commas.
#
# @param value
#   The string to quote.
#
# @return [String] The value in double quotes, with `\` and `"` escaped.
function dnsmasq::quote(String $value) >> String {
  $escaped = $value.regsubst('\\\\', '\\\\\\\\', 'G').regsubst('"', '\\\\"', 'G')
  "\"${escaped}\""
}
