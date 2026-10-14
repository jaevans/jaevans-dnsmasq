# frozen_string_literal: true

source 'https://rubygems.org'

group :test do
  # jgrep (via facterdb) calls JSON.create_id=, which json 3 removed.
  gem 'json', '< 3', require: false
  gem 'puppet_metadata', '~> 6.0', require: false
  gem 'voxpupuli-test', '~> 15.0', require: false
end

group :system_tests do
  gem 'voxpupuli-acceptance', '~> 4.4', require: false
end

gem 'openvox', ENV.fetch('OPENVOX_GEM_VERSION', ['>= 8', '< 10']), require: false
gem 'rake', require: false
