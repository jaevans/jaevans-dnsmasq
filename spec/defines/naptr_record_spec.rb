# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::naptr_record' do
  include_context 'with a dnsmasq define', 'naptr-record'
  let(:title) { 'example.com' }
  let(:params) { { naptr_order: 100, preference: 10, flags: 'S', service: 'SIP+D2U', regexp: '', replacement: '_sip._udp.example.com' } }

  it { renders("naptr-record=example.com,100,10,S,SIP+D2U,,_sip._udp.example.com\n") }
end
