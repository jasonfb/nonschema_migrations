
# this is the generator used to create a data migration

class DataMigrationGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path("../data_migrations/templates/", __FILE__)

  desc <<-DESC
Description:
    Creates new nonschema migration
DESC

  def create_data_migration_file
    @path = args[0]
    migration_template "migration.rb", "db/data_migrate/#{file_name}.rb"
  end


  def file_name
    "#{next_migration_number}_#{@path.downcase}"
  end

  def next_migration_number
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end


  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  # 'migration.rb' now requires this var/method
  def migration_action
    'create'
  end

  private

  # this used in migration template which is inherited, we want this values to be an empty array.
  def attributes
    []
  end
end

