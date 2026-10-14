# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker(modules: :metadata) do |host|
  install_package(host, host['platform'].start_with?('el-') ? 'bind-utils' : 'bind9-dnsutils')
end
