# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::srv_host' do
  include_context 'with a dnsmasq define', 'srv-host'
  let(:title) { '_ldap._tcp.example.com' }

  context 'with all fields' do
    let(:params) { { target: 'ldap.example.com', port: 389, priority: 10, weight: 100 } }

    it { renders("srv-host=_ldap._tcp.example.com,ldap.example.com,389,10,100\n") }
  end

  context 'with target and port' do
    let(:params) { { target: 'ldap.example.com', port: 389 } }

    it { renders("srv-host=_ldap._tcp.example.com,ldap.example.com,389\n") }
  end

  context 'with no target' do
    it { renders("srv-host=_ldap._tcp.example.com\n") }
  end

  context 'with weight but no priority' do
    let(:params) { { target: 'ldap.example.com', port: 389, weight: 100 } }

    it { is_expected.to compile.and_raise_error(%r{weight requires priority}) }
  end

  context 'with a name that is not _service._proto' do
    let(:title) { 'ldap.example.com' }

    it { is_expected.to compile.and_raise_error(%r{service}) }
  end
end
