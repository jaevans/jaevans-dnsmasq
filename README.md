# dnsmasq

[![CI](https://github.com/jaevans/jaevans-dnsmasq/actions/workflows/ci.yml/badge.svg)](https://github.com/jaevans/jaevans-dnsmasq/actions/workflows/ci.yml)

Manage [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) — DNS, DHCP, TFTP and PXE — entirely from Hiera.

```puppet
include dnsmasq
```

## How it works

`/etc/dnsmasq.conf` contains a single line, `conf-dir=/etc/dnsmasq.d,*.conf`. Everything else is written to
`/etc/dnsmasq.d`:

| File | Contents |
| --- | --- |
| `10-options.conf` | The free-form `dnsmasq::options` hash |
| `50-<option>.conf` | One file per typed resource, e.g. `50-host-record.conf`, `50-dhcp-host.conf` |

Files in `/etc/dnsmasq.d` that Puppet does not manage are deleted (`dnsmasq::purge_config_dir`), so Hiera is the
whole configuration. Each file is checked with `dnsmasq --test` before it is written (`dnsmasq::validate_config`), and
any change restarts the service: dnsmasq does not reread `conf-dir` on SIGHUP.

Platform specifics handled for you:

* **Debian family** — the packaged service passes `/etc/default/dnsmasq`'s `CONFIG_DIR` to dnsmasq as well, which
  would load every file twice. The module sets `CONFIG_DIR=` and leaves the rest of that file alone.
* **RedHat family** — the stock `/etc/dnsmasq.conf` sets `user`, `group` and `local-service=host`. The module's
  defaults put them in `dnsmasq::options`; override any of them, or set it to `false` to omit it. `local-service` has
  no effect once `interface`, `except-interface` or `listen-address` is set.

## Usage

Every hash parameter on the `dnsmasq` class creates resources of a defined type, keyed by title, and is deep-merged
across your Hiera hierarchy, so common data and per-node data combine.

```yaml
dnsmasq::options:
  domain: example.com
  expand-hosts: true
  domain-needed: true
  dhcp-authoritative: true
  dhcp-fqdn: true
  cache-size: 0
  except-interface: eth0
  resolv-file: /etc/resolv.dnsmasq
  rebind-domain-ok: /plex.direct/
  enable-tftp: true
  tftp-root: /srv/tftp

dnsmasq::dhcp_ranges:
  home:
    start: 192.0.2.60
    end: 192.0.2.100
    netmask: 255.255.255.0
    lease_time: 2d
    set: home

dnsmasq::dhcp_options:
  home router:
    option: router
    value: 192.0.2.1
    tags: home
  home search:
    option: domain-search
    value: [example.com, lab.example.com]
    tags: home
  dns:
    option: dns-server
    value: 192.0.2.10

dnsmasq::dhcp_hosts:
  printer:
    mac: '00:11:22:33:44:55'
    ip: 192.0.2.40

dnsmasq::host_records:
  printer.example.com:
    ip: 192.0.2.40
  cluster.example.com:
    ip: [192.0.2.21, 192.0.2.22, 192.0.2.23]

dnsmasq::cnames:
  www.example.com:
    target: printer.example.com

dnsmasq::srv_hosts:
  _ldap._tcp.example.com:
    target: ldap.example.com
    port: 389
    priority: 10
    weight: 100

dnsmasq::addresses:
  # Answer NXDOMAIN for unknown names in example.com rather than forwarding them.
  example.com: {}
```

### The `options` hash

Keys are dnsmasq's own long option names without the leading dashes, exactly as in `man dnsmasq`. Values:

| Value | Written as |
| --- | --- |
| `true` | `option` |
| `false` | nothing (useful to remove an inherited or OS default) |
| string or integer | `option=value` |
| array | `option=value`, once per element |

Use it for any option that has no typed resource.

### Typed resources

| Class parameter | Defined type | dnsmasq option |
| --- | --- | --- |
| `host_records` | `dnsmasq::host_record` | `host-record` |
| `cnames` | `dnsmasq::cname` | `cname` |
| `addresses` | `dnsmasq::address` | `address` |
| `servers` | `dnsmasq::server` | `server` |
| `mx_hosts` | `dnsmasq::mx_host` | `mx-host` |
| `srv_hosts` | `dnsmasq::srv_host` | `srv-host` |
| `txt_records` | `dnsmasq::txt_record` | `txt-record` |
| `ptr_records` | `dnsmasq::ptr_record` | `ptr-record` |
| `naptr_records` | `dnsmasq::naptr_record` | `naptr-record` |
| `caa_records` | `dnsmasq::caa_record` | `caa-record` |
| `dns_rrs` | `dnsmasq::dns_rr` | `dns-rr` |
| `dhcp_ranges` | `dnsmasq::dhcp_range` | `dhcp-range` |
| `dhcp_hosts` | `dnsmasq::dhcp_host` | `dhcp-host` |
| `dhcp_options` | `dnsmasq::dhcp_option` | `dhcp-option`, `dhcp-option-force` |
| `dhcp_boots` | `dnsmasq::dhcp_boot` | `dhcp-boot` |
| `dhcp_matches` | `dnsmasq::dhcp_match` | `dhcp-match` |
| `tag_ifs` | `dnsmasq::tag_if` | `tag-if` |
| `dhcp_vendorclasses` | `dnsmasq::dhcp_vendorclass` | `dhcp-vendorclass` |
| `pxe_services` | `dnsmasq::pxe_service` | `pxe-service` |

Parameter names are snake_case because Puppet does not allow dashes in them. Parameters that select clients by tag
are called `tags` (`tag` is a Puppet metaparameter); `set` names the tag to set. Every type takes `order`, the
position of its line within its file; lines sort numerically, then by title. Order matters for `tag-if`, which runs
top to bottom, and for `dhcp-boot`, where the first match wins.

The defined types can also be declared directly in manifests. See [REFERENCE.md](REFERENCE.md) for every parameter.

#### Notes

* `host_record`: dnsmasq takes one IPv4 and one IPv6 address per `host-record` line, so further addresses are written
  as further lines for the same name. Only the first address gets a PTR record.
* `dhcp_host`: `hostname` defaults to the title. Set it to `false` to omit it.
* `txt_record` strings and `pxe_service` menu text are quoted, so they may contain commas.

## Requirements

* OpenVox 8 or 9
* [puppetlabs/stdlib](https://forge.puppet.com/modules/puppetlabs/stdlib) and
  [puppetlabs/concat](https://forge.puppet.com/modules/puppetlabs/concat)
* dnsmasq 2.90 or later

| OS | dnsmasq |
| --- | --- |
| Debian 12 | 2.90 |
| Debian 13 | 2.91 |
| Ubuntu 22.04, 24.04 | 2.91 |
| Ubuntu 26.04 | 2.92 |
| RHEL, AlmaLinux, Rocky 10 | 2.90 |

Typed resources only produce syntax that dnsmasq 2.90 accepts. Options added in 2.91 (`dhcp-option-pxe`,
`do-0x20-encode`, `no-0x20-encode`) can be set through `dnsmasq::options` on systems that have 2.91.

Out of scope: boot images, iPXE menus and other files served over TFTP. Manage those in your own profile.

## Development

No PDK is needed.

```sh
bundle install
bundle exec rake test            # syntax, lint, metadata, unit tests
bundle exec rake rubocop
bundle exec rake strings:generate:reference   # regenerate REFERENCE.md

# Acceptance tests run dnsmasq under OpenVox in Docker and query it with dig.
BEAKER_SETFILE=debian13-64 BEAKER_PUPPET_COLLECTION=openvox9 bundle exec rake beaker
```

On Apple silicon, use `BEAKER_SETFILE=debian13-AARCH64`.

CI runs the unit tests against OpenVox 8 and 9 on every supported OS's facts, and acceptance tests against
OpenVox 8 and 9 on Debian 13.

## License

Apache-2.0
