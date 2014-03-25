source 'https://rubygems.org'

gem 'rails', '4.0.3'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'ejs'
gem 'trueskill', git: 'git://github.com/saulabs/trueskill.git', require: 'saulabs/trueskill'

group :production do
  gem 'pg'
  gem 'rails_serve_static_assets'
  gem 'rails_on_heroku'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails.git', tag: 'v3.0.0.beta2'
  gem 'capybara'
  gem 'poltergeist'
  gem 'jasmine'
  gem 'timecop'
end
