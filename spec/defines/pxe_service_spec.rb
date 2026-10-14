# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::pxe_service' do
  include_context 'with a dnsmasq define', 'pxe-service'
  let(:title) { 'bios' }

  context 'with a basename' do
    let(:params) { { csa: 'x86PC', menu_text: 'PXE Boot (BIOS)', basename: 'bios/lpxelinux', server: '192.0.2.9', tags: 'pxe' } }

    it { renders(%(pxe-service=tag:pxe,x86PC,"PXE Boot (BIOS)",bios/lpxelinux,192.0.2.9\n)) }
  end

  context 'with a boot service type' do
    let(:params) { { csa: 'x86PC', menu_text: 'Local', boot_service_type: 0 } }

    it { renders(%(pxe-service=x86PC,"Local",0\n)) }
  end

  context 'with a server but nothing to boot' do
    let(:params) { { csa: 'x86PC', menu_text: 'x', server: '192.0.2.9' } }

    it { is_expected.to compile.and_raise_error(%r{server requires}) }
  end
end
