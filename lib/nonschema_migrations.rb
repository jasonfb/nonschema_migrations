
MIGRATIONS_PATH = 'db/data_migrate'

require 'generators/data_migrations/install_generator.rb'
require 'generators/data_migration_generator.rb'
require 'active_record/data_migration.rb'
require 'nonschema_migrator.rb'

module NonschemaMigrations
  require "nonschema_migrations/railtie.rb" if defined?(Rails)
end