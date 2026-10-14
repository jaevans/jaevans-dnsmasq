# Changelog

## 0.1.0 (unreleased)

Initial release.

* `dnsmasq` class: package, a `conf-dir`-only `/etc/dnsmasq.conf`, a purged `/etc/dnsmasq.d`, and the service.
* Free-form `dnsmasq::options` hash written to `10-options.conf`.
* Typed resources, one file per type: `host_record`, `cname`, `address`, `server`, `mx_host`, `srv_host`,
  `txt_record`, `ptr_record`, `naptr_record`, `caa_record`, `dns_rr`, `dhcp_range`, `dhcp_host`, `dhcp_option`,
  `dhcp_boot`, `dhcp_match`, `tag_if`, `dhcp_vendorclass`, `pxe_service`.
* Every file validated with `dnsmasq --test` before it is written.
* OpenVox 8 and 9; Debian 12/13, Ubuntu 22.04/24.04/26.04, EL 10.
