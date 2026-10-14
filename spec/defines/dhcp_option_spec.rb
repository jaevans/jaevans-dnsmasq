# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::dhcp_option' do
  include_context 'with a dnsmasq define', 'dhcp-option'
  let(:title) { 'home router' }

  context 'with a bare option name' do
    let(:params) { { option: 'router', value: '192.0.2.1', tags: 'home' } }

    it { renders("dhcp-option=tag:home,option:router,192.0.2.1\n") }
  end

  context 'with a list value' do
    let(:params) { { option: 'option:domain-search', value: ['example.com', 'lab.example.com'] } }

    it { renders("dhcp-option=option:domain-search,example.com,lab.example.com\n") }
  end

  context 'with an IPv6 option' do
    let(:params) { { option: 'option6:dns-server', value: '[2001:db8::53]' } }

    it { renders("dhcp-option=option6:dns-server,[2001:db8::53]\n") }
  end

  context 'forced, numeric and encapsulated' do
    let(:params) { { option: 1, value: '0.0.0.0', vendor: 'PXEClient', force: true, tags: 'ipxe-ok' } }

    it { renders("dhcp-option-force=tag:ipxe-ok,vendor:PXEClient,1,0.0.0.0\n") }
  end

  context 'with encap and vi-encap' do
    let(:params) { { option: 190, value: 'iscsi', encap: 175 } }

    it { renders("dhcp-option=encap:175,190,iscsi\n") }
  end
end
