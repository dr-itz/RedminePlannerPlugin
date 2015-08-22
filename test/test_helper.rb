require 'simplecov'

if Dir.pwd.match(/plugins\/planner/)
  covdir = 'coverage'
else
  covdir = 'plugins/planner/coverage'
end

SimpleCov.coverage_dir(covdir)
SimpleCov.start 'rails' do
  add_filter do |source_file|
    # only show files belonging to planner, except init.rb which is not fully testable
    source_file.filename.match(/planner/) == nil ||
      source_file.filename.match(/planner\/init.rb/) != nil
  end
end

# Load the normal Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

# Ensure that we are using the plugin's fixtures

fixture_path = File.expand_path("../fixtures2", __FILE__)
if Redmine::VERSION::MAJOR == 3
  fixture_path = File.expand_path("../fixtures3", __FILE__)
end

ActiveSupport::TestCase.fixture_path = fixture_path
ActionDispatch::IntegrationTest.fixture_path = fixture_path

# Verbose logging if required
#ActiveRecord::Base.logger = Logger.new(STDOUT)
