# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::quote' do
  it { is_expected.to run.with_params('a, b').and_return('"a, b"') }
  it { is_expected.to run.with_params('say "hi"').and_return('"say \"hi\""') }
  it { is_expected.to run.with_params('back\\slash').and_return('"back\\\\slash"') }
end
