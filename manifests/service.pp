# @summary Run dnsmasq.
#
# Changes restart the service: SIGHUP does not make dnsmasq reread `conf-dir`.
#
# @api private
class dnsmasq::service {
  assert_private()

  if $dnsmasq::manage_service {
    service { $dnsmasq::service_name:
      ensure => $dnsmasq::service_ensure,
      enable => $dnsmasq::service_enable,
    }
  }
}
