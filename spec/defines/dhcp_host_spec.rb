# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::dhcp_host' do
  include_context 'with a dnsmasq define', 'dhcp-host'
  let(:title) { 'printer' }

  context 'with a MAC and address' do
    let(:params) { { mac: '00:11:22:33:44:55', ip: '192.0.2.40' } }

    it { renders("dhcp-host=00:11:22:33:44:55,192.0.2.40,printer\n") }
  end

  context 'with every field' do
    let(:params) do
      {
        mac: ['00:11:22:33:44:55', '66:77:88:99:aa:bb'],
        client_id: '*',
        set: 'printers',
        tags: 'office',
        ip: ['192.0.2.40', '2001:db8::40'],
        hostname: 'laser',
        lease_time: 'infinite',
      }
    end

    it { renders("dhcp-host=00:11:22:33:44:55,66:77:88:99:aa:bb,id:*,set:printers,tag:office,192.0.2.40,[2001:db8::40],laser,infinite\n") }
  end

  context 'ignoring a host without a hostname' do
    let(:params) { { mac: '00:11:22:33:44:*', hostname: false, ignore: true } }

    it { renders("dhcp-host=00:11:22:33:44:*,ignore\n") }
  end

  context 'with a malformed MAC' do
    let(:params) { { mac: '00:11:22' } }

    it { is_expected.to compile.and_raise_error(%r{mac}) }
  end
end
