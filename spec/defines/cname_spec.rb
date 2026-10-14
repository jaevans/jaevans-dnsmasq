# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::cname' do
  include_context 'with a dnsmasq define', 'cname'
  let(:title) { 'www.example.com' }
  let(:params) { { target: 'web.example.com' } }

  it { renders("cname=www.example.com,web.example.com\n") }

  context 'with several aliases and a TTL' do
    let(:params) { { target: 'web.example.com', aliases: %w[a.example.com b.example.com], ttl: 60 } }

    it { renders("cname=a.example.com,b.example.com,web.example.com,60\n") }
  end
end
