# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::server' do
  include_context 'with a dnsmasq define', 'server'
  let(:title) { 'upstream' }

  context 'with only an address' do
    let(:params) { { ip: '192.0.2.53' } }

    it { renders("server=192.0.2.53\n") }
  end

  context 'with domains, port, interface and source' do
    let(:params) { { ip: '10.0.0.53', domains: ['corp.example.com', ''], port: 5353, interface: 'eth1', source: '10.0.0.2#1053' } }

    it { renders("server=/corp.example.com//10.0.0.53#5353@eth1@10.0.0.2#1053\n") }
  end

  context 'with domains only' do
    let(:params) { { domains: ['local.example.com'] } }

    it { renders("server=/local.example.com/\n") }
  end

  context 'with neither' do
    it { is_expected.to compile.and_raise_error(%r{set ip, domains, or both}) }
  end
end
