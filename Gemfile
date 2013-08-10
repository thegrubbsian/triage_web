source "https://rubygems.org"

gem "active_model_serializers", "0.8.1"
gem "bcrypt-ruby", "~> 3.0.0", require: "bcrypt"
gem "pg"
gem "rails", "4.0.0"
gem "settingslogic", "2.0.9"

group :production do
  gem "unicorn"
end

group :development do
  gem "foreman"
end

group :development, :test do
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails"
  gem "thin"
end
