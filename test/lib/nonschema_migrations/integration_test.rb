require_relative '../../test_helper'

# require 'active_record/migration'
# require 'rails/railties/lib/rails/tasks'

require 'tasks/data.rb'
class IntegrationTest < Minitest::Test
  def setup
    @oldpath = Dir.pwd
    Dir.chdir DUMMY_APP_ROOT
    FileUtils.rm_rf("db")
    assert_equal 'db/data_migrate', MIGRATIONS_PATH
    FileUtils::mkdir_p './db/data_migrate'
    dummy_migration_file = File.open( "db/data_migrate/20140101125959_create_users.rb","w" )
    dummy_migration_file <<  <<-eos
    class CreateUsers < ActiveRecord::Migration[5.2]
      def change
        reversible do |dir|
          dir.up do
            User.create!(name:"foo")
            User.create!(name:"bar")
          end
        end
      end
    end
eos
    dummy_migration_file.close

    FileUtils::mkdir_p './db/migrate'
    db_migration_file = File.open( "db/migrate/20140101125959_create_users.rb","w" )
    db_migration_file <<  <<-eos
    class CreateUsers < ActiveRecord::Migration[5.2]
      def change
        create_table :users do |t|
          t.string :name
        end
      end
    end
eos
    db_migration_file.close

    if Rails.version >= Gem::Version.new('7.0')
      ActiveRecord::Base.configurations = YAML.load(File.read('config/database_integration.yml'))
    end

    ActiveRecord::Base.establish_connection
    Rails.application.load_tasks
  end
  def teardown
    FileUtils.rm_rf("db")
    Dir.chdir(@oldpath)
  end

  def test_data_migrate
    Rails::Generators.invoke('data_migrations:install')
    Rails.application.load_tasks
    Rake::Task['db:migrate'].invoke
    Rake::Task['data:migrate'].invoke

    assert_equal ["bar", "foo"], User.pluck(:name).sort
  end
end