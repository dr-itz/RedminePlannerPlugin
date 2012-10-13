# this is an ugly hack, but it works somehow
if RUBY_VERSION < "1.9"
  require 'rcov/rcovtask'

  namespace :planner do
    namespace :coverage do

      desc 'Runs the all plugins tests (units/functionals/integration).'
      Rcov::RcovTask.new :all => ["db:test:prepare"] do |t|
        t.rcov_opts << "-Iplugins/planner -x 'bundler/*,gems/*' -x 'redmine'"
        t.libs << "test"
        t.test_files =
          FileList["plugins/planner/test/unit/**/*_test.rb"] +
          FileList["plugins/planner/test/functional/**/*_test.rb"] +
          FileList["plugins/planner/test/integration/**/*_test.rb"]
        # t.verbose = true     # uncomment to see the executed command
      end
    end
  end
end
