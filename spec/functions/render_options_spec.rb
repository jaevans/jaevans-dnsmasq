# frozen_string_literal: true

require 'spec_helper'

describe 'dnsmasq::render_options' do
  it { is_expected.to run.with_params({}).and_return('') }

  it 'renders flags, values and repeated options in hash order, omitting false' do
    is_expected.to run.with_params(
      'domain' => 'example.com',
      'expand-hosts' => true,
      'no-hosts' => false,
      'cache-size' => 0,
      'rebind-domain-ok' => ['/plex.direct/', '/example.net/'],
    ).and_return(<<~CONF)
      domain=example.com
      expand-hosts
      cache-size=0
      rebind-domain-ok=/plex.direct/
      rebind-domain-ok=/example.net/
    CONF
  end

  it { is_expected.to run.with_params('--domain' => 'x').and_raise_error(ArgumentError) }
end
