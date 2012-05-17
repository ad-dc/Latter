ENV['RACK_ENV'] = 'test'

require 'bundler/setup'
Bundler.require

require 'simplecov'
SimpleCov.start

# Require RSpec helpers
require 'capybara/rspec'
require 'capybara/webkit'
require 'rack/test'
require 'factory_girl'
require 'bcrypt'

# Load FactoryGirl definitions
FactoryGirl.find_definitions

# Require application
require File.join(File.dirname(__FILE__), '..', 'latter')

# Require supporting files
Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each { |file| require file }

RSpec.configure do |config|
  config.before(:all)  do
    Capybara.app = app
    Capybara.default_driver = :webkit

    # Make sure we are testing in a sandbox by deleting
    # existing Players and Challenges
    Player.destroy
    Game.destroy
    Activity.destroy
  end
end

def app
  Latter
end
