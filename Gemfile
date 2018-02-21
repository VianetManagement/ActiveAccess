# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :development, :test do
  gem "rubocop", "~> 0.52", require: false
  gem "simplecov", require: false, group: :test

  gem "dotenv", "~> 2.2"
  gem "faker", "~> 1.8"
  gem "rake", "~> 10.4"

  gem "byebug", "~> 9.0", ">= 9.0.6"
  gem "pry", "~> 0.11.3"
  gem "pry-byebug", "~> 3.5", ">= 3.5.1"
end

# Specify your gem's dependencies in active_access.gemspec
gemspec
