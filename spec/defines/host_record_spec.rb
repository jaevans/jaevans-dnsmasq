# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::host_record' do
  include_context 'with a dnsmasq define', 'host-record'
  let(:title) { 'router.example.com' }

  context 'with one IPv4 address' do
    let(:params) { { ip: '192.0.2.1' } }

    it { is_expected.to compile.with_all_deps }
    it { renders("host-record=router.example.com,192.0.2.1\n") }
  end

  context 'with IPv4 and IPv6, extra names and a TTL' do
    let(:params) { { ip: ['192.0.2.1', '2001:db8::1'], names: %w[router router.example.com], ttl: 300 } }

    it { renders("host-record=router,router.example.com,192.0.2.1,2001:db8::1,300\n") }
  end

  context 'with several IPv4 addresses' do
    let(:params) { { ip: ['192.0.2.1', '192.0.2.2', '2001:db8::1'] } }

    it { renders("host-record=router.example.com,192.0.2.1,2001:db8::1\nhost-record=router.example.com,192.0.2.2\n") }
  end

  context 'with a CIDR address' do
    let(:params) { { ip: '192.0.2.1/24' } }

    it { is_expected.to compile.and_raise_error(%r{ip}) }
  end
end
