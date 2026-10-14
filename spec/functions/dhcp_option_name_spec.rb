# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::dhcp_option_name' do
  it { is_expected.to run.with_params(3).and_return('3') }
  it { is_expected.to run.with_params('176').and_return('176') }
  it { is_expected.to run.with_params('router').and_return('option:router') }
  it { is_expected.to run.with_params('option:router').and_return('option:router') }
  it { is_expected.to run.with_params('option6:dns-server').and_return('option6:dns-server') }
  it { is_expected.to run.with_params('vi-encap:4491').and_return('vi-encap:4491') }
end
