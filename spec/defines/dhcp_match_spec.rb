# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::dhcp_match' do
  include_context 'with a dnsmasq define', 'dhcp-match'
  let(:title) { 'ipxe-http' }
  let(:params) { { option: 175, value: 19 } }

  it { renders("dhcp-match=set:ipxe-http,175,19\n") }

  context 'with a named option' do
    let(:title) { 'efi-x64' }
    let(:params) { { option: 'client-arch', value: 7 } }

    it { renders("dhcp-match=set:efi-x64,option:client-arch,7\n") }
  end
end
