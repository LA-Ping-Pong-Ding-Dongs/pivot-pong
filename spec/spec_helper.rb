ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/poltergeist'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.include StructBuilder
  config.include FeatureHelper, type: :feature
  config.use_transactional_fixtures = true
  config.order = 'random'

  config.after(:each) do
    Player.delete_all
    Match.delete_all
  end

end
