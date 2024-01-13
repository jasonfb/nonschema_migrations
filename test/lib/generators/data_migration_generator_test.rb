require_relative '../../test_helper'

#
# require "rails"

# This is the class that will test the datamigration generators

class DataMigrationGeneratorTest < Rails::Generators::TestCase
  tests DataMigrationGenerator
  destination File.expand_path("../../tmp", File.dirname(__FILE__))

  setup :prepare_destination

  teardown :destroy_files

  def destroy_files
    FileUtils.rm_rf("test/tmp/db/data_migrate/")
  end

  def test_migration
    migration = "hello_world_migration"
    run_generator [migration]
    assert_migration "db/data_migrate/hello_world_migration.rb"
  end

  # doesn't pass on travis consistently
  # def test_file_is_created
  #   migration = "xyz"
  #   run_generator [migration]
  #   generated_filename = Dir.entries("test/tmp/db/data_migrate/")[2]
  #   assert_equal 14, (generated_filename =~ /_xyz.rb$/)
  # end
end