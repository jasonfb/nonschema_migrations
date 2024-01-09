require_relative '../../test_helper'

# require 'active_record/migration'
# require 'rails/railties/lib/rails/tasks'

require 'tasks/data.rb'
class DataMigrations::RailtieTest < Minitest::Test
  def setup
    @oldpath = Dir.pwd
    Dir.chdir DUMMY_APP_ROOT
    assert_equal 'db/data_migrate', MIGRATIONS_PATH
    FileUtils::mkdir_p './db/data_migrate'
    dummy_migration_file = File.open( "db/data_migrate/20140101125959_xyz.rb","w" )
    dummy_migration_file <<  <<-eos
    class Xyz < ActiveRecord::Migration[5.2]
      def up
      end

      def down
      end
    end
eos
    dummy_migration_file.close

    if Gem::Version.new(Rails.version) >= Gem::Version.new('7.0')
      ActiveRecord::Base.configurations = YAML.load(File.read('config/database.yml'))
    end

    ActiveRecord::Base.establish_connection

    ActiveRecord::Base.connection.create_table :data_migrations, id: false do |t|
      t.string :version
    end

    Rake::Task.define_task(:environment)
  end

  # teardown :destroy_files

  def teardown
    FileUtils.rm_rf("db/data_migrate/")
    Dir.chdir @oldpath
  end

  def test_that_the_migrate_task_can_run
    NonschemaMigrator.expects(:migrate).with(MIGRATIONS_PATH)
    Rake::Task['data:migrate'].execute
  end

  def test_that_the_rollback_task_can_run
    skip "TODO implemnent rollback"

    #ActiveRecord::Tasks::DataTasks.expects(:rollback).with(MIGRATIONS_PATH)
    # assert Rake::Task['data:rollback'].invoke
  end

  def test_that_the_up_task_can_run
    NonschemaMigrator.expects(:run).with(:up, MIGRATIONS_PATH, 20140101125959, nil)
    ENV['VERSION'] = "20140101125959"
    Rake::Task['data:migrate:up'].invoke
  ensure
    ENV.delete("VERSION")
  end

  def test_that_the_down_task_can_run
    NonschemaMigrator.expects(:run).with(:down, MIGRATIONS_PATH, 00000000000000)
    ENV['VERSION'] = "00000000000000"
    Rake::Task['data:migrate:down'].invoke("VERSION=00000000000000")
  ensure
    ENV.delete("VERSION")
  end
end