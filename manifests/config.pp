# @summary Write the main configuration file and one concat target per record type.
# @api private
class dnsmasq::config {
  assert_private()

  # Must list every `file` passed to dnsmasq::fragment by the defined types.
  $type_files = [
    'host-record', 'cname', 'address', 'server', 'mx-host', 'srv-host', 'txt-record',
    'ptr-record', 'naptr-record', 'caa-record', 'dns-rr', 'dhcp-range', 'dhcp-host',
    'dhcp-option', 'dhcp-boot', 'dhcp-match', 'tag-if', 'dhcp-vendorclass', 'pxe-service',
  ]

  $validate_cmd = $dnsmasq::validate_config ? {
    true    => "${dnsmasq::dnsmasq_binary} --test --conf-file=%",
    default => undef,
  }

  file { $dnsmasq::config_file:
    ensure       => file,
    owner        => 'root',
    group        => 'root',
    mode         => '0644',
    content      => "# Managed by Puppet\nconf-dir=${dnsmasq::config_dir},*.conf\n",
    validate_cmd => $validate_cmd,
    require      => File[$dnsmasq::config_dir],
  }

  file { $dnsmasq::config_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => $dnsmasq::purge_config_dir,
    purge   => $dnsmasq::purge_config_dir,
    force   => $dnsmasq::purge_config_dir,
  }

  if $dnsmasq::defaults_file {
    file_line { 'dnsmasq CONFIG_DIR':
      path  => $dnsmasq::defaults_file,
      line  => 'CONFIG_DIR=',
      match => '^#?\s*CONFIG_DIR=',
    }
  }

  file { "${dnsmasq::config_dir}/10-options.conf":
    ensure       => file,
    owner        => 'root',
    group        => 'root',
    mode         => '0644',
    content      => "# Managed by Puppet\n${dnsmasq::render_options($dnsmasq::options)}",
    validate_cmd => $validate_cmd,
  }

  $type_files.each |$type| {
    concat { "${dnsmasq::config_dir}/50-${type}.conf":
      ensure       => present,
      owner        => 'root',
      group        => 'root',
      mode         => '0644',
      order        => 'numeric',
      validate_cmd => $validate_cmd,
    }

    concat::fragment { "dnsmasq ${type} header":
      target  => "${dnsmasq::config_dir}/50-${type}.conf",
      content => "# Managed by Puppet\n",
      order   => 0,
    }
  }
}
