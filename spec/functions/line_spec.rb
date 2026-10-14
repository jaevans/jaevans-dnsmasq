# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::line' do
  it { is_expected.to run.with_params('expand-hosts').and_return("expand-hosts\n") }
  it { is_expected.to run.with_params('domain', ['example.com']).and_return("domain=example.com\n") }
  it { is_expected.to run.with_params('cache-size', [0]).and_return("cache-size=0\n") }
  it { is_expected.to run.with_params('cname', [%w[a b], 'c', nil]).and_return("cname=a,b,c\n") }
  it { is_expected.to run.with_params('dhcp-boot', ['menu.ipxe', nil, '192.0.2.1']).and_return("dhcp-boot=menu.ipxe,,192.0.2.1\n") }
  it { is_expected.to run.with_params('dhcp-boot', ['menu.ipxe', nil, nil]).and_return("dhcp-boot=menu.ipxe\n") }
  it { is_expected.to run.with_params('local-ttl', [nil]).and_return("local-ttl\n") }
end
