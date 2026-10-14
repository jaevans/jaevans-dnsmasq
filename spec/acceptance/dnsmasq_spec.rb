# frozen_string_literal: true

require 'spec_helper_acceptance'

def dig(args)
  command("dig +short @127.0.0.1 #{args}").stdout.lines.map(&:strip).sort
end

describe 'dnsmasq' do
  manifest = <<~PUPPET
    class { 'dnsmasq':
      options       => {
        'listen-address'   => '127.0.0.1',
        'bind-interfaces'  => true,
        'no-resolv'        => true,
        'domain'           => 'example.test',
        'rebind-domain-ok' => ['/plex.direct/', '/example.net/'],
      },
      host_records  => {
        'web.example.test' => { 'ip' => ['192.0.2.10', '192.0.2.11', '2001:db8::10'] },
        'ldap.example.test' => { 'ip' => '192.0.2.20' },
      },
      cnames        => { 'www.example.test' => { 'target' => 'web.example.test' } },
      addresses     => { 'blocked.example.test' => { 'ip' => '0.0.0.0' } },
      srv_hosts     => {
        '_ldap._tcp.example.test' => { 'target' => 'ldap.example.test', 'port' => 389, 'priority' => 10, 'weight' => 100 },
      },
      mx_hosts      => { 'example.test' => { 'hostname' => 'web.example.test', 'preference' => 10 } },
      txt_records   => { 'example.test' => { 'text' => ['v=spf1 mx -all', 'a,b "c"'] } },
      ptr_records   => { '_http._tcp.example.test' => { 'target' => 'web._http._tcp.example.test' } },
      caa_records   => { 'example.test' => { 'property' => 'issue', 'value' => 'letsencrypt.org' } },
      naptr_records => {
        'sip.example.test' => { 'naptr_order' => 100, 'preference' => 10, 'flags' => 'S', 'service' => 'SIP+D2U', 'regexp' => '', 'replacement' => '_sip._udp.example.test' },
      },
      dns_rrs       => { 'rr.example.test' => { 'rr_type' => 65280, 'data' => '0568656c6c6f' } },
      dhcp_ranges   => { 'test' => { 'start' => '198.51.100.50', 'end' => '198.51.100.99', 'netmask' => '255.255.255.0', 'lease_time' => '2d', 'set' => 'test' } },
      dhcp_hosts    => { 'printer' => { 'mac' => '00:11:22:33:44:55', 'ip' => '198.51.100.40' } },
      dhcp_options  => { 'test router' => { 'option' => 'router', 'value' => '198.51.100.1', 'tags' => 'test' } },
      dhcp_matches  => { 'ipxe-efi' => { 'option' => 175, 'value' => 36 } },
      tag_ifs       => { 'ipxe-ok' => { 'set' => 'ipxe-ok', 'tags' => ['ipxe-efi'] } },
      dhcp_boots    => { 'ipxe' => { 'filename' => 'menu.ipxe', 'server_address' => '198.51.100.9', 'tags' => 'ipxe-ok' } },
      dhcp_vendorclasses => { 'pxe' => { 'vendor_class' => 'PXEClient' } },
      pxe_services  => { 'bios' => { 'csa' => 'x86PC', 'menu_text' => 'PXE Boot (BIOS)', 'basename' => 'bios/lpxelinux', 'tags' => 'pxe' } },
    }
  PUPPET

  context 'with every record and DHCP type' do
    # Examples run in random order, so everything they check is set up here.
    before(:all) do
      shell('mkdir -p /etc/dnsmasq.d && echo "address=/stray.example.test/192.0.2.99" > /etc/dnsmasq.d/stray.conf')
      apply_manifest(manifest, catch_failures: true)
    end

    it 'is idempotent' do
      apply_manifest(manifest, catch_changes: true)
    end

    describe service('dnsmasq') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    it 'purges unmanaged files' do
      expect(file('/etc/dnsmasq.d/stray.conf')).not_to exist
    end

    it 'accepts the whole configuration' do
      expect(command('dnsmasq --test').exit_status).to eq 0
    end

    it 'reads the configuration directory only once' do
      args = command('ps -o args= -C dnsmasq').stdout
      expect(args).to include('dnsmasq')
      expect(args).not_to match(%r{ -7 | --conf-dir})
    end

    it('answers every address of a host_record') { expect(dig('web.example.test A')).to eq %w[192.0.2.10 192.0.2.11] }
    it('answers AAAA') { expect(dig('web.example.test AAAA')).to eq ['2001:db8::10'] }
    it('answers PTR for the first address') { expect(dig('-x 192.0.2.10')).to eq ['web.example.test.'] }
    it('answers CNAME') { expect(dig('www.example.test A')).to include('web.example.test.') }
    it('answers address') { expect(dig('anything.blocked.example.test A')).to eq ['0.0.0.0'] }
    it('answers SRV') { expect(dig('_ldap._tcp.example.test SRV')).to eq ['10 100 389 ldap.example.test.'] }
    it('answers MX') { expect(dig('example.test MX')).to eq ['10 web.example.test.'] }
    it('answers TXT, keeping commas and quotes') { expect(dig('example.test TXT')).to eq ['"v=spf1 mx -all" "a,b \\"c\\""'] }
    it('answers PTR records') { expect(dig('_http._tcp.example.test PTR')).to eq ['web._http._tcp.example.test.'] }
    it('answers CAA') { expect(dig('example.test CAA')).to eq ['0 issue "letsencrypt.org"'] }
    it('answers NAPTR') { expect(dig('sip.example.test NAPTR')).to eq ['100 10 "S" "SIP+D2U" "" _sip._udp.example.test.'] }
    it('answers dns_rr') { expect(dig('rr.example.test TYPE65280')).to eq ['\\# 6 0568656C6C6F'] }
  end

  context 'with an option dnsmasq rejects' do
    it 'refuses to write the file and leaves the running config in place' do
      bad = manifest.sub("'no-resolv'        => true,", "'no-resolv' => true, 'not-a-real-option' => true,")
      apply_manifest(bad, expect_failures: true)
      expect(file('/etc/dnsmasq.d/10-options.conf').content).not_to include('not-a-real-option')
      expect(dig('web.example.test A')).to eq %w[192.0.2.10 192.0.2.11]
    end
  end
end
