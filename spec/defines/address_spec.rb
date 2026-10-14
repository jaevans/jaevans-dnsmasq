# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::address' do
  include_context 'with a dnsmasq define', 'address'
  let(:title) { 'example.com' }

  it { renders("address=/example.com/\n") }

  context 'with an address and several domains' do
    let(:params) { { domains: %w[ads.example.net tracker.example.net], ip: '0.0.0.0' } }

    it { renders("address=/ads.example.net/tracker.example.net/0.0.0.0\n") }
  end

  context 'with the null address' do
    let(:params) { { ip: '#' } }

    it { renders("address=/example.com/#\n") }
  end
end
