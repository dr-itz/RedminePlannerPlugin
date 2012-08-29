# mostly from Redmine r9738
namespace :planner do
  namespace :test do
    desc 'Runs the plugins unit tests.'
    Rake::TestTask.new :units => "db:test:prepare" do |t|
      t.libs << "test"
      t.verbose = true
      t.test_files = FileList["plugins/planner/test/unit/**/*_test.rb"]
    end

    desc 'Runs the plugins functional tests.'
    Rake::TestTask.new :functionals => "db:test:prepare" do |t|
      t.libs << "test"
      t.verbose = true
      t.test_files = FileList["plugins/planner/test/functional/**/*_test.rb"]
    end

    desc 'Runs the plugins integration tests.'
    Rake::TestTask.new :integration => "db:test:prepare" do |t|
      t.libs << "test"
      t.verbose = true
      t.test_files = FileList["plugins/planner/test/integration/**/*_test.rb"]
    end
  end
end
