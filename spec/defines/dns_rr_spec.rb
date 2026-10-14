# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::dns_rr' do
  include_context 'with a dnsmasq define', 'dns-rr'
  let(:title) { 'host.example.com' }
  let(:params) { { rr_type: 44, data: '0101abcd' } }

  it { renders("dns-rr=host.example.com,44,0101abcd\n") }

  context 'with non-hex data' do
    let(:params) { { rr_type: 44, data: 'zz' } }

    it { is_expected.to compile.and_raise_error(%r{data}) }
  end
end
