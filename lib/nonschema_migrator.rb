require_relative "./active_record/data_tasks.rb"

class NonschemaMigrator

  # include ActiveRecord::Tasks::DatabaseTasks

  # This class related to data migration.
  # Used in rake tasks (rake data:[migrate|rollback|up|down])


  def self.migrate(version = nil)
    ActiveRecord::Tasks::DataTasks.migrate(version)
  end

  def self.rollback
    ActiveRecord::Tasks::DataTasks.rollback
  end

  def initialize(direction, migrations, no_op, target_version = nil)
    # @direction         = direction
    # @target_version    = target_version
    # @migrated_versions = nil
    # @migrations        = migrations
    #
    # validate(@migrations)
    #
    # ActiveRecord::DataMigration.create_table
  end

  # if defined?(ActiveRecord::MigrationContext)
  #   class NonSchemaMigration < ActiveRecord::SchemaMigration
  #     def self.table_name
  #       NonschemaMigrator.schema_migrations_table_name
  #     end
  #
  #     def self.get_all_versions
  #       versions
  #     end
  #
  #     def versions
  #       sm = Arel::SelectManager.new(arel_table)
  #       sm.project(arel_table[primary_key])
  #       sm.order(arel_table[primary_key].asc)
  #
  #       connection.select_values(sm, "#{self.class} Load")
  #     end
  #   end
  #
  #   class MigrationContext < ActiveRecord::MigrationContext
  #     def initialize(migrations_paths, data_migration)
  #
  #       # super(migrations_paths, data_migration)
  #       @migrations_paths = migrations_paths
  #
  #       @schema_migration = NonschemaMigrator::NonSchemaMigration
  #     end
  #
  #     def new_migrator(*args)
  #       result = NonschemaMigrator.new(*args)
  #       result.migration_context = self
  #       result
  #     end
  #
  #     def schema_migrations_table_name
  #       'data_migrations'
  #     end
  #
  #     # these methods are copied from ActiveRecord::Migrator
  #     # replaced:
  #     #  1.) ActiveRecord::NonSchemaMigration with @schema_migration
  #     #  2.) ActiveRecord::Migrator.new with new_migrator
  #
  #     def get_all_versions
  #       byebug
  #       if connection.table_exists?(schema_migrations_table_name)
  #         @schema_migration.all_versions.map(&:to_i)
  #       else
  #         []
  #       end
  #     end
  #
  #     def migrations_status
  #       db_list = @schema_migration.normalized_versions
  #
  #       file_list = migration_files.map do |file|
  #         version, name, scope = parse_migration_filename(file)
  #         raise IllegalMigrationNameError.new(file) unless version
  #         version = @schema_migration.normalize_migration_number(version)
  #         status = db_list.delete(version) ? "up" : "down"
  #         [status, version, (name + scope).humanize]
  #       end.compact
  #
  #       db_list.map! do |version|
  #         ["up", version, "********** NO FILE **********"]
  #       end
  #
  #       (db_list + file_list).sort_by { |_, version, _| version }
  #     end
  #
  #     def rollback(steps)
  #       move(:down, steps)
  #     end
  #
  #     def move(direction, steps)
  #       migrator = new_migrator(direction, migrations, nil, schema_migration)
  #
  #       if current_version != 0 && !migrator.current_migration
  #         raise UnknownMigrationVersionError.new(current_version)
  #       end
  #
  #       start_index =
  #         if current_version == 0
  #           0
  #         else
  #           migrator.migrations.index(migrator.current_migration)
  #         end
  #
  #       finish = migrator.migrations[start_index + steps]
  #       version = finish ? finish.version : 0
  #       send(direction, version)
  #     end
  #
  #     def up(target_version = nil)
  #       selected_migrations = if block_given?
  #                               migrations.select { |m| yield m }
  #                             else
  #                               migrations
  #                             end
  #
  #       new_migrator(:up, selected_migrations, nil, target_version).migrate
  #     end
  #
  #     def down(target_version = nil)
  #       selected_migrations = if block_given?
  #                               migrations.select { |m| yield m }
  #                             else
  #                               migrations
  #                             end
  #
  #       new_migrator(:down, selected_migrations, nil, target_version).migrate
  #     end
  #   end
  #
  #   class << self
  #     def context(path)
  #       NonschemaMigrator::MigrationContext.new(path, ActiveRecord::DataMigration)
  #     end
  #
  #     def new_migrator(path, *args)
  #       result = self.new(*args)
  #       result.migration_context=context(path)
  #       result
  #     end
  #
  #     def migrate(path)
  #       context(path).migrate()
  #     end
  #
  #     def rollback(path, steps = 1)
  #       context(path).rollback(steps)
  #     end
  #
  #     def run(direction, path, target_version)
  #       new_migrator(path, direction, context(path).migrations, nil, target_version).run
  #     end
  #   end
  #
  #   def migration_context=(context)
  #     @migration_context = context
  #   end
  #
  #   def load_migrated
  #     @migrated_versions = Set.new(@migration_context.get_all_versions)
  #   end
  #
  #   def schema_migrations_table_name
  #     'data_migrations'
  #   end
  #
  # end
  #
  # def record_version_state_after_migrating(version)
  #   if down?
  #     migrated.delete(version)
  #     ActiveRecord::DataMigration.where(:version => version.to_s).delete_all
  #   else
  #     migrated << version
  #     ActiveRecord::DataMigration.create!(:version => version.to_s)
  #   end
  # end
  #
  #
  # class <<self
  #   def migrations_path
  #     MIGRATIONS_PATH
  #   end
  #
  #   def schema_migrations_table_name
  #     'data_migrations'
  #   end
  #
  #   def get_all_versions(connection = ActiveRecord::Base.connection)
  #     if connection.table_exists?(schema_migrations_table_name)
  #       ActiveRecord::DataMigration.all.map { |x| x.version.to_i }.sort
  #     else
  #       []
  #     end
  #   end
  # end
end

