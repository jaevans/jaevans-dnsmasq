# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::tags' do
  it { is_expected.to run.with_params.and_return([]) }
  it { is_expected.to run.with_params('home').and_return(['tag:home']) }
  it { is_expected.to run.with_params(%w[a !b], 'c').and_return(['tag:a', 'tag:!b', 'set:c']) }
  it { is_expected.to run.with_params(nil, %w[x y]).and_return(['set:x', 'set:y']) }
  it { is_expected.to run.with_params('a,b').and_raise_error(ArgumentError) }
end
