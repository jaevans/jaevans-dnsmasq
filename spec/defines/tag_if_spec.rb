# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::tag_if' do
  include_context 'with a dnsmasq define', 'tag-if'
  let(:title) { 'ipxe-ok efi' }
  let(:params) { { set: 'ipxe-ok', tags: %w[ipxe-http ipxe-menu ipxe-efi], order: 10 } }

  it { renders("tag-if=set:ipxe-ok,tag:ipxe-http,tag:ipxe-menu,tag:ipxe-efi\n") }
  it { is_expected.to contain_concat__fragment(fragment).with_order(10) }
end
