# frozen_string_literal: true

begin
  require 'voxpupuli/test/rake'
rescue LoadError
  # voxpupuli-test is only available in the test group
end

begin
  require 'voxpupuli/acceptance/rake'
rescue LoadError
  # voxpupuli-acceptance is only available in the system_tests group
end
