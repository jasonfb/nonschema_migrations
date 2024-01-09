# start simplecov
require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

begin
  require 'byebug'
rescue LoadError
end

# require what the gem & tests need
require 'rails'
require 'minitest'
require 'minitest/autorun'
require 'minitest/rg'

require_relative './dummy_app/init'
Bundler.require(*Rails.groups)

# setup correct load path
$LOAD_PATH << '.' unless $LOAD_PATH.include?('.')
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
$:.unshift File.expand_path(File.dirname(__FILE__))

# require the gem itself
require 'lib/nonschema_migrations.rb'

require 'lib/nonschema_migrations/railtie' if defined?(Rails)

Dir['lib/generators/*.rb'].sort.each { |f| require f }
Dir['lib/nonschema_migrations/*.rb'].sort.each { |f| require f }
Dir['lib/*.rb'].sort.each { |f| require f }

require 'mocha/minitest'
require 'active_record/migration'
require 'active_record/railtie'
require 'rails/railtie'

DUMMY_APP_ROOT = File.expand_path(File.join(__dir__, '/dummy_app'))

Dir.chdir DUMMY_APP_ROOT
