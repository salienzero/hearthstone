require 'rubygems'

require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/cache/'
end

require 'bundler'
Bundler.require(:test)

# Load all models
model_path = File.join(File.dirname(__FILE__), "..", "models", "**", "*.rb")
Dir.glob(model_path).each { |f| require f }

RSpec.configure do |config|
  config.color = true
  config.tty = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
