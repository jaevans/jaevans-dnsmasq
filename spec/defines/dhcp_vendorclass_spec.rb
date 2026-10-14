# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::dhcp_vendorclass' do
  include_context 'with a dnsmasq define', 'dhcp-vendorclass'
  let(:title) { 'pxe' }
  let(:params) { { vendor_class: 'PXEClient' } }

  it { renders("dhcp-vendorclass=set:pxe,PXEClient\n") }
end
