source "https://rubygems.org"

ruby "3.4.5"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.0"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use Vite for managing front-end assets
gem "vite_rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Inertia Rails adapter
gem "inertia_rails", "~> 3.0"

# UML Store gem for UML 2.5 model storage
gem "uml-store", git: "https://github.com/magenticmarketactualskill/uml-store.git"

# Authentication
gem "devise", "~> 4.9"

# Authorization
gem "pundit", "~> 2.3"

# GitHub's design system components
gem "primer_view_components", "~> 0.15"

# RDF support for UML Store
gem "rdf", "~> 3.3"
gem "rdf-vocab", "~> 3.3"
gem "shacl", "~> 0.4"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # RSpec for testing
  gem "rspec-rails", "~> 6.1"
  
  # Factory Bot for test fixtures
  gem "factory_bot_rails", "~> 6.4"
  
  # Faker for generating test data
  gem "faker", "~> 3.2"
  
  # Pry for debugging
  gem "pry-rails"
  gem "pry-byebug"
end

group :test do
  # Cucumber for BDD testing
  gem "cucumber-rails", require: false
  
  # Database cleaner
  gem "database_cleaner-active_record"
  
  # Shoulda matchers for testing
  gem "shoulda-matchers", "~> 6.0"
  
  # Capybara for integration testing
  gem "capybara"
  
  # Selenium WebDriver for browser testing
  gem "selenium-webdriver"
  
  # SimpleCov for code coverage
  gem "simplecov", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Annotate models with schema information
  gem "annotate"
  
  # Better error pages
  gem "better_errors"
  gem "binding_of_caller"
end
