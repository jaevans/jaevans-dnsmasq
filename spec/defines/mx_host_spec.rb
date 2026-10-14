# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::mx_host' do
  include_context 'with a dnsmasq define', 'mx-host'
  let(:title) { 'example.com' }

  it { renders("mx-host=example.com\n") }

  context 'with hostname and preference' do
    let(:params) { { hostname: 'mail.example.com', preference: 10 } }

    it { renders("mx-host=example.com,mail.example.com,10\n") }
  end
end
