# @summary Add lines to one of the per-type configuration files.
#
# @api private
#
# @param file
#   The per-type file, named after its dnsmasq option, e.g. `host-record` for
#   `50-host-record.conf`. Must be one of the files declared in `dnsmasq::config`.
# @param content
#   The rendered lines.
# @param order
#   The position within the file.
define dnsmasq::fragment (
  String[1] $file,
  String $content,
  Dnsmasq::Order $order = 50,
) {
  assert_private()
  include dnsmasq

  concat::fragment { "dnsmasq ${title}":
    target  => "${dnsmasq::config_dir}/50-${file}.conf",
    content => $content,
    order   => $order,
  }
}
