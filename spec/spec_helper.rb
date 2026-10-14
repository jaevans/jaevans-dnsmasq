# frozen_string_literal: true

require 'voxpupuli/test/spec_helper'

add_mocked_facts!

# Facts for specs that exercise a defined type on a single platform.
DEBIAN13_FACTS = on_supported_os(supported_os: [{ 'operatingsystem' => 'Debian', 'operatingsystemrelease' => ['13'] }]).values.first

RSpec.shared_context 'with a dnsmasq define' do |file|
  let(:facts) { DEBIAN13_FACTS }
  let(:fragment) { "dnsmasq #{file} #{title}" }
  let(:target) { "/etc/dnsmasq.d/50-#{file}.conf" }

  def renders(content)
    is_expected.to contain_concat__fragment(fragment).with(target: target, content: content)
  end
end
