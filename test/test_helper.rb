if !(RUBY_VERSION < "1.9")
  require 'simplecov'

  if Dir.pwd.match(/plugins\/planner/)
    covdir = 'coverage'
  else
    covdir = 'plugins/planner/coverage'
  end

  SimpleCov.coverage_dir(covdir)
  SimpleCov.start 'rails' do
    add_filter do |source_file|
      source_file.filename.match(/planner/) == nil
    end
  end
end

# Load the normal Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

# Ensure that we are using the plugin's fixtures
ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)

# Verbose logging if required
#ActiveRecord::Base.logger = Logger.new(STDOUT)
