# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::dhcp_range' do
  include_context 'with a dnsmasq define', 'dhcp-range'
  let(:title) { 'home' }

  context 'with an IPv4 range' do
    let(:params) { { start: '192.0.2.50', end: '192.0.2.99', netmask: '255.255.255.0', lease_time: '2d', set: 'home' } }

    it { is_expected.to compile.with_all_deps }
    it { renders("dhcp-range=set:home,192.0.2.50,192.0.2.99,255.255.255.0,2d\n") }
  end

  context 'with an IPv4 static mode and match tags' do
    let(:params) { { start: '192.0.2.0', modes: ['static'], tags: %w[lab !guest] } }

    it { renders("dhcp-range=tag:lab,tag:!guest,192.0.2.0,static\n") }
  end

  context 'with an IPv6 constructor range' do
    let(:params) { { start: '::', constructor: 'eth0.9', modes: ['ra-names'], prefix_length: 64, lease_time: '24h', set: 'home6' } }

    it { renders("dhcp-range=set:home6,::,constructor:eth0.9,ra-names,64,24h\n") }
  end

  context 'with an IPv6 range and integer lease but no prefix length' do
    let(:params) { { start: '2001:db8::10', end: '2001:db8::99', lease_time: 3600 } }

    it { is_expected.to compile.and_raise_error(%r{requires prefix_length}) }
  end

  context 'with an IPv4 range and a constructor' do
    let(:params) { { start: '192.0.2.50', constructor: 'eth0' } }

    it { is_expected.to compile.and_raise_error(%r{IPv6 only}) }
  end

  context 'with broadcast but no netmask' do
    let(:params) { { start: '192.0.2.50', end: '192.0.2.99', broadcast: '192.0.2.255' } }

    it { is_expected.to compile.and_raise_error(%r{broadcast requires netmask}) }
  end
end
