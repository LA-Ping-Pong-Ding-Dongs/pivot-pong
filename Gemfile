source 'https://rubygems.org'
ruby '2.1.0'

gem 'rails', '4.0.3'

gem 'apipie-rails'
gem 'draper'
gem 'ejs'
gem 'font-awesome-sass'
gem 'jbuilder'
gem 'jquery-rails'
gem 'kaminari'
gem 'pg'
gem 'psych', '~> 2.0.5'
gem 'sass-rails', '~> 4.0.0'
gem 'trueskill', git: 'git://github.com/saulabs/trueskill.git', require: 'saulabs/trueskill'
gem 'uglifier', '>= 1.3.0'
gem 'virtus'

group :production, :staging do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'license_finder'
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails.git', tag: 'v3.0.0.beta2'
  gem 'capybara', git: 'https://github.com/jnicklas/capybara.git', branch: 'master'
  gem 'poltergeist', '~> 1.5.0'
  gem 'jasmine', '~> 2.0.0'
  gem 'timecop'
  gem 'faker'
end

group :test do
  gem 'nyan-cat-formatter', git: 'https://github.com/mattsears/nyan-cat-formatter.git', branch: 'master'
end
