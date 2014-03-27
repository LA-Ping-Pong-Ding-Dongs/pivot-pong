source 'https://rubygems.org'
ruby '2.1.0'

gem 'rails', '4.0.3'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'ejs'
gem 'trueskill', git: 'git://github.com/saulabs/trueskill.git', require: 'saulabs/trueskill'
gem 'pg'


group :production, :staging do
  gem 'rails_serve_static_assets'
  gem 'rails_on_heroku'
end

group :development, :test do
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails.git', tag: 'v3.0.0.beta2'
  gem 'capybara', '~> 2.2.1'
  gem 'poltergeist', '~> 1.5.0'
  gem 'jasmine', '~> 2.0.0'
  gem 'timecop'
end
