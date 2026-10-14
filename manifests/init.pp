# @summary Manage dnsmasq from Hiera.
#
# `/etc/dnsmasq.conf` only loads `config_dir`. Free-form options are written to
# `10-options.conf`; each typed resource is written to one file per type, such as
# `50-host-record.conf`. Every hash parameter below creates resources of the named
# defined type, keyed by title, and is deep-merged across the Hiera hierarchy.
#
# @example Hiera
#   dnsmasq::options:
#     domain: example.com
#     expand-hosts: true
#     dhcp-authoritative: true
#   dnsmasq::host_records:
#     router.example.com:
#       ip: 192.0.2.1
#   dnsmasq::dhcp_ranges:
#     home:
#       start: 192.0.2.50
#       end: 192.0.2.99
#       lease_time: 2d
#
# @param manage_package
#   Whether to manage the dnsmasq package.
# @param package_name
#   The dnsmasq package name.
# @param package_ensure
#   The `ensure` value for the package.
# @param manage_service
#   Whether to manage the dnsmasq service.
# @param service_name
#   The dnsmasq service name.
# @param service_ensure
#   The `ensure` value for the service.
# @param service_enable
#   Whether the service starts at boot.
# @param config_file
#   The main configuration file. Puppet replaces its contents with a single `conf-dir` line.
# @param config_dir
#   The directory holding every managed configuration file.
# @param purge_config_dir
#   Whether to delete files in `config_dir` that Puppet does not manage.
# @param defaults_file
#   The Debian-family `/etc/default/dnsmasq`. Its `CONFIG_DIR` is emptied so that the
#   service does not pass `config_dir` to dnsmasq a second time. `undef` on other families.
# @param dnsmasq_binary
#   The dnsmasq executable, used to validate files before they are written.
# @param validate_config
#   Whether to check each file with `dnsmasq --test` before writing it.
# @param options
#   dnsmasq long option names, without dashes, mapped to values. `true` writes a bare
#   flag, `false` omits the option, and an array writes the option once per element.
# @param host_records
#   `dnsmasq::host_record` resources.
# @param cnames
#   `dnsmasq::cname` resources.
# @param addresses
#   `dnsmasq::address` resources.
# @param servers
#   `dnsmasq::server` resources.
# @param mx_hosts
#   `dnsmasq::mx_host` resources.
# @param srv_hosts
#   `dnsmasq::srv_host` resources.
# @param txt_records
#   `dnsmasq::txt_record` resources.
# @param ptr_records
#   `dnsmasq::ptr_record` resources.
# @param naptr_records
#   `dnsmasq::naptr_record` resources.
# @param caa_records
#   `dnsmasq::caa_record` resources.
# @param dns_rrs
#   `dnsmasq::dns_rr` resources.
# @param dhcp_ranges
#   `dnsmasq::dhcp_range` resources.
# @param dhcp_hosts
#   `dnsmasq::dhcp_host` resources.
# @param dhcp_options
#   `dnsmasq::dhcp_option` resources.
# @param dhcp_boots
#   `dnsmasq::dhcp_boot` resources.
# @param dhcp_matches
#   `dnsmasq::dhcp_match` resources.
# @param tag_ifs
#   `dnsmasq::tag_if` resources.
# @param dhcp_vendorclasses
#   `dnsmasq::dhcp_vendorclass` resources.
# @param pxe_services
#   `dnsmasq::pxe_service` resources.
class dnsmasq (
  Boolean $manage_package = true,
  String[1] $package_name = 'dnsmasq',
  String[1] $package_ensure = 'installed',
  Boolean $manage_service = true,
  String[1] $service_name = 'dnsmasq',
  Stdlib::Ensure::Service $service_ensure = 'running',
  Boolean $service_enable = true,
  Stdlib::Absolutepath $config_file = '/etc/dnsmasq.conf',
  Stdlib::Absolutepath $config_dir = '/etc/dnsmasq.d',
  Boolean $purge_config_dir = true,
  Optional[Stdlib::Absolutepath] $defaults_file = undef,
  Stdlib::Absolutepath $dnsmasq_binary = '/usr/sbin/dnsmasq',
  Boolean $validate_config = true,
  Hash[Dnsmasq::OptionName, Dnsmasq::OptionValue] $options = {},
  Hash[String[1], Hash] $host_records = {},
  Hash[String[1], Hash] $cnames = {},
  Hash[String[1], Hash] $addresses = {},
  Hash[String[1], Hash] $servers = {},
  Hash[String[1], Hash] $mx_hosts = {},
  Hash[String[1], Hash] $srv_hosts = {},
  Hash[String[1], Hash] $txt_records = {},
  Hash[String[1], Hash] $ptr_records = {},
  Hash[String[1], Hash] $naptr_records = {},
  Hash[String[1], Hash] $caa_records = {},
  Hash[String[1], Hash] $dns_rrs = {},
  Hash[String[1], Hash] $dhcp_ranges = {},
  Hash[String[1], Hash] $dhcp_hosts = {},
  Hash[String[1], Hash] $dhcp_options = {},
  Hash[String[1], Hash] $dhcp_boots = {},
  Hash[String[1], Hash] $dhcp_matches = {},
  Hash[String[1], Hash] $tag_ifs = {},
  Hash[String[1], Hash] $dhcp_vendorclasses = {},
  Hash[String[1], Hash] $pxe_services = {},
) {
  contain dnsmasq::install
  contain dnsmasq::config
  contain dnsmasq::service

  Class['dnsmasq::install']
  -> Class['dnsmasq::config']
  ~> Class['dnsmasq::service']

  $resource_hashes = {
    'dnsmasq::host_record'      => $host_records,
    'dnsmasq::cname'            => $cnames,
    'dnsmasq::address'          => $addresses,
    'dnsmasq::server'           => $servers,
    'dnsmasq::mx_host'          => $mx_hosts,
    'dnsmasq::srv_host'         => $srv_hosts,
    'dnsmasq::txt_record'       => $txt_records,
    'dnsmasq::ptr_record'       => $ptr_records,
    'dnsmasq::naptr_record'     => $naptr_records,
    'dnsmasq::caa_record'       => $caa_records,
    'dnsmasq::dns_rr'           => $dns_rrs,
    'dnsmasq::dhcp_range'       => $dhcp_ranges,
    'dnsmasq::dhcp_host'        => $dhcp_hosts,
    'dnsmasq::dhcp_option'      => $dhcp_options,
    'dnsmasq::dhcp_boot'        => $dhcp_boots,
    'dnsmasq::dhcp_match'       => $dhcp_matches,
    'dnsmasq::tag_if'           => $tag_ifs,
    'dnsmasq::dhcp_vendorclass' => $dhcp_vendorclasses,
    'dnsmasq::pxe_service'      => $pxe_services,
  }

  $resource_hashes.each |$type, $resources| {
    $resources.each |$title, $params| {
      Resource[$type] { $title: * => $params }
    }
  }
}
