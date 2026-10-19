# frozen_string_literal: true

source 'https://rubygems.org'

group :test do
  # jgrep (via facterdb) calls JSON.create_id=, which json 3 removed.
  gem 'json', '2.21.2', require: false
  gem 'puppet_metadata', '6.4.0', require: false
  gem 'voxpupuli-test', '15.0.0', require: false
end

group :system_tests do
  gem 'voxpupuli-acceptance', '4.4.0', require: false
end

gem 'openvox', ENV.fetch('OPENVOX_GEM_VERSION', '9.1.0'), require: false
gem 'rake', '13.4.2', require: false
