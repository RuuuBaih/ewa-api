# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Web Application
gem 'econfig', '~> 2.1'
gem 'puma', '~> 3.11'
gem 'roda', '~> 3.8'
gem 'slim', '~> 3.0'

# Validation
gem 'dry-struct', '~> 1.3'
gem 'dry-types', '~> 1.4'

# Networking
gem 'http', '~> 4.0'

# Database
gem 'hirb', '~> 0.7'
gem 'hirb-unicode'
gem 'sequel', '~> 5.0'


group :development, :test do
  gem 'database_cleaner', '~> 1.8'
  gem 'sqlite3', '~> 1.4'
end

# Testing
group :test do
    gem 'minitest', '~> 5.0'
    gem 'minitest-rg', '~> 5.0'
    gem 'simplecov', '~> 0'
    gem 'vcr', '~> 6.0'
    gem 'webmock', '~> 3.0'
end

group :development, :test do
    gem 'rerun', '~> 0.13'
end

# Debugging: see https://stackify.com/ruby-debugger-using-visual-studio-code/
gem 'debase', '~> 0.2'
gem 'ruby-debug-ide', '~> 0.7'

# Quality
group :development, :test do
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end

# Utilities
gem 'rake'

group :production do
  gem 'pg'
end