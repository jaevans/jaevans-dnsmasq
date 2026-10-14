# @summary Install dnsmasq.
# @api private
class dnsmasq::install {
  assert_private()

  if $dnsmasq::manage_package {
    package { $dnsmasq::package_name:
      ensure => $dnsmasq::package_ensure,
    }
  }
}
