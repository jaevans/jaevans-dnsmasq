# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::txt_record' do
  include_context 'with a dnsmasq define', 'txt-record'
  let(:title) { 'example.com' }
  let(:params) { { text: ['v=spf1 mx -all', 'a,b "c"'] } }

  it { renders(%(txt-record=example.com,"v=spf1 mx -all","a,b \\"c\\""\n)) }
end
