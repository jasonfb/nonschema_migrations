require 'test_helper'

require 'lib/active_record/data_tasks'
# require 'rails'
# require 'active_record/migration'

class NonschemaMigratorTest < Minitest::Test
  def test_nondestructive_migrator
    assert NonschemaMigrator
  end

  def test_schema_migrations_table_name
    assert_equal 'data_migrations', ActiveRecord::Tasks::DataTasks.data_migrations_table_name
  end

  def test_migrations_path
    # assert_equal ['db/data_migrate'], ActiveRecord::Tasks::DataTasks.migrations_paths
  end
end