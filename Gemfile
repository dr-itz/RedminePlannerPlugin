source 'http://rubygems.org'

group :development, :test do
  gem 'annotate'
#  gem 'rspec-rails'
#  gem 'capybara'
#  gem 'database_cleaner'

  # hack - :platforms => [:mri_18] does not always work
  if RUBY_VERSION < "1.9"
    platforms :mri_18 do
      gem 'rcov', :require => false
    end
  end

  gem 'simplecov', :require => false
end
