# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::ptr_record' do
  include_context 'with a dnsmasq define', 'ptr-record'
  let(:title) { '1.2.0.192.in-addr.arpa' }
  let(:params) { { target: 'router.example.com' } }

  it { renders("ptr-record=1.2.0.192.in-addr.arpa,router.example.com\n") }
end
