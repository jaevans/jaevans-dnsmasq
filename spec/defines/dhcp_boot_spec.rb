# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::dhcp_boot' do
  include_context 'with a dnsmasq define', 'dhcp-boot'
  let(:title) { 'ipxe menu' }
  let(:params) { { filename: 'menu.ipxe', server_address: '192.0.2.9', tags: 'ipxe-ok' } }

  it { renders("dhcp-boot=tag:ipxe-ok,menu.ipxe,,192.0.2.9\n") }

  context 'with only a filename' do
    let(:params) { { filename: 'pxelinux.0' } }

    it { renders("dhcp-boot=pxelinux.0\n") }
  end
end
