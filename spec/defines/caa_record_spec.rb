# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::caa_record' do
  include_context 'with a dnsmasq define', 'caa-record'
  let(:title) { 'example.com' }
  let(:params) { { property: 'issue', value: 'letsencrypt.org' } }

  it { renders("caa-record=example.com,0,issue,letsencrypt.org\n") }
end
