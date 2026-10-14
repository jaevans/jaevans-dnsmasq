# frozen_string_literal: true

require 'spec_helper'

TYPE_FILES = %w[
  host-record cname address server mx-host srv-host txt-record ptr-record naptr-record
  caa-record dns-rr dhcp-range dhcp-host dhcp-option dhcp-boot dhcp-match tag-if
  dhcp-vendorclass pxe-service
].freeze

EXPECTED_RESOURCES = {
  host_record: 'a.example.com', cname: 'b.example.com', address: 'example.com', server: 'up',
  mx_host: 'example.com', srv_host: '_sip._udp.example.com', txt_record: 'example.com',
  ptr_record: '1.2.0.192.in-addr.arpa', naptr_record: 'example.com', caa_record: 'example.com',
  dns_rr: 'example.com', dhcp_range: 'home', dhcp_host: 'printer', dhcp_option: 'router',
  dhcp_boot: 'pxe', dhcp_match: 'ipxe', tag_if: 'ok', dhcp_vendorclass: 'pxe', pxe_service: 'local',
}.freeze

describe 'dnsmasq' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:redhat) { os_facts[:os]['family'] == 'RedHat' }

      context 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('dnsmasq').with_ensure('installed') }
        it { is_expected.to contain_service('dnsmasq').with(ensure: 'running', enable: true) }
        it { is_expected.to contain_class('dnsmasq::install').that_comes_before('Class[dnsmasq::config]') }
        it { is_expected.to contain_class('dnsmasq::config').that_notifies('Class[dnsmasq::service]') }

        it do
          is_expected.to contain_file('/etc/dnsmasq.conf').with(
            content: "# Managed by Puppet\nconf-dir=/etc/dnsmasq.d,*.conf\n",
            validate_cmd: '/usr/sbin/dnsmasq --test --conf-file=%',
          )
        end

        it { is_expected.to contain_file('/etc/dnsmasq.d').with(ensure: 'directory', recurse: true, purge: true) }

        TYPE_FILES.each do |type|
          it do
            is_expected.to contain_concat("/etc/dnsmasq.d/50-#{type}.conf").with(
              order: 'numeric',
              validate_cmd: '/usr/sbin/dnsmasq --test --conf-file=%',
            )
          end
        end

        it 'writes the OS default options' do
          expected = redhat ? "user=dnsmasq\ngroup=dnsmasq\nlocal-service=host\n" : ''
          is_expected.to contain_file('/etc/dnsmasq.d/10-options.conf').with_content("# Managed by Puppet\n#{expected}")
        end

        it 'empties CONFIG_DIR only on the Debian family' do
          if redhat
            is_expected.not_to contain_file_line('dnsmasq CONFIG_DIR')
          else
            is_expected.to contain_file_line('dnsmasq CONFIG_DIR').with(
              path: '/etc/default/dnsmasq', line: 'CONFIG_DIR=', match: '^#?\s*CONFIG_DIR=',
            )
          end
        end
      end

      context 'with management and validation turned off' do
        let(:params) { { manage_package: false, manage_service: false, purge_config_dir: false, validate_config: false } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_package('dnsmasq') }
        it { is_expected.not_to contain_service('dnsmasq') }
        it { is_expected.to contain_file('/etc/dnsmasq.d').with(recurse: false, purge: false) }
        it { is_expected.to contain_file('/etc/dnsmasq.conf').without_validate_cmd }
      end

      context 'with every resource hash' do
        let(:params) do
          {
            host_records: { 'a.example.com' => { 'ip' => '192.0.2.1' } },
            cnames: { 'b.example.com' => { 'target' => 'a.example.com' } },
            addresses: { 'example.com' => {} },
            servers: { 'up' => { 'ip' => '192.0.2.53' } },
            mx_hosts: { 'example.com' => { 'hostname' => 'a.example.com' } },
            srv_hosts: { '_sip._udp.example.com' => { 'target' => 'a.example.com', 'port' => 5060 } },
            txt_records: { 'example.com' => { 'text' => 'hello' } },
            ptr_records: { '1.2.0.192.in-addr.arpa' => { 'target' => 'a.example.com' } },
            naptr_records: { 'example.com' => { 'naptr_order' => 1, 'preference' => 1, 'flags' => 'S', 'service' => 'SIP+D2U', 'regexp' => '' } },
            caa_records: { 'example.com' => { 'property' => 'issue', 'value' => 'ca.example' } },
            dns_rrs: { 'example.com' => { 'rr_type' => 99, 'data' => '00' } },
            dhcp_ranges: { 'home' => { 'start' => '192.0.2.50', 'end' => '192.0.2.99' } },
            dhcp_hosts: { 'printer' => { 'mac' => '00:11:22:33:44:55' } },
            dhcp_options: { 'router' => { 'option' => 'router', 'value' => '192.0.2.1' } },
            dhcp_boots: { 'pxe' => { 'filename' => 'pxelinux.0' } },
            dhcp_matches: { 'ipxe' => { 'option' => 175 } },
            tag_ifs: { 'ok' => { 'set' => 'ok', 'tags' => 'ipxe' } },
            dhcp_vendorclasses: { 'pxe' => { 'vendor_class' => 'PXEClient' } },
            pxe_services: { 'local' => { 'csa' => 'x86PC', 'menu_text' => 'Local', 'boot_service_type' => 0 } },
          }
        end

        it { is_expected.to compile.with_all_deps }

        it 'declares a resource for every hash entry' do
          EXPECTED_RESOURCES.each { |type, title| expect(subject).to send("contain_dnsmasq__#{type}", title) }
        end
      end

      context 'with an unknown option name' do
        let(:params) { { options: { 'Bad Name' => true } } }

        it { is_expected.to compile.and_raise_error(%r{options}) }
      end

      context 'with Hiera data at two levels' do
        let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_dnsmasq__host_record('router.example.com') }
        it { is_expected.to contain_dnsmasq__host_record('nas.example.com') }
        it { is_expected.to contain_dnsmasq__cname('files.example.com') }
        it { is_expected.to contain_concat__fragment('dnsmasq srv-host _ldap._tcp.example.com').with_content("srv-host=_ldap._tcp.example.com,ldap.example.com,389\n") }

        it 'deep-merges options from every level, including the module data' do
          os_defaults = redhat ? "user=dnsmasq\ngroup=dnsmasq\nlocal-service=host\n" : ''
          content = catalogue.resource('File', '/etc/dnsmasq.d/10-options.conf')[:content]
          expect(content.lines.sort).to eq("# Managed by Puppet\ncache-size=0\ndomain=example.com\nexpand-hosts\n#{os_defaults}".lines.sort)
        end
      end
    end
  end
end
