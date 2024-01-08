
# frozen_string_literal: true

require "active_record/database_configurations"

module ActiveRecord
  module Tasks # :nodoc:
    class DatabaseNotSupported < StandardError; end # :nodoc:


    module DataTasks
      ##
      # :singleton-method:
      # Extra flags passed to database CLI tool (mysqldump/pg_dump) when calling db:schema:dump
      # It can be used as a string/array (the typical case) or a hash (when you use multiple adapters)
      # Example:
      #   ActiveRecord::Tasks::DatabaseTasks.structure_dump_flags = {
      #     mysql2: ['--no-defaults', '--skip-add-drop-table'],
      #     postgres: '--no-tablespaces'
      #   }
      mattr_accessor :structure_dump_flags, instance_accessor: false

      ##
      # :singleton-method:
      # Extra flags passed to database CLI tool when calling db:schema:load
      # It can be used as a string/array (the typical case) or a hash (when you use multiple adapters)
      mattr_accessor :structure_load_flags, instance_accessor: false

      extend self

      attr_writer :data_dir, :migrations_paths, :fixtures_path, :root, :env, :seed_loader
      attr_accessor :database_configuration


      def self.data_migrations_table_name
        "data_migrations"
      end

      def check_protected_environments!(environment = env)
        return if ENV["DISABLE_DATABASE_ENVIRONMENT_CHECK"]

        configs_for(env_name: environment).each do |db_config|
          check_current_protected_environment!(db_config)
        end
      end

      def register_task(pattern, task)
        @tasks ||= {}
        @tasks[pattern] = task
      end

      register_task(/mysql/,        "ActiveRecord::Tasks::MySQLDatabaseTasks")
      register_task(/trilogy/,      "ActiveRecord::Tasks::MySQLDatabaseTasks")
      register_task(/postgresql/,   "ActiveRecord::Tasks::PostgreSQLDatabaseTasks")
      register_task(/sqlite/,       "ActiveRecord::Tasks::SQLiteDatabaseTasks")

      def data_dir
        @data_dir ||= Rails.application.config.paths["data"].first
      end

      def migrations_paths
        @migrations_paths ||= Rails.application.paths["data/migrate"].to_a
      end

      def parse_migration_filename(filename)
        File.basename(filename).scan(Migration::MigrationFilenameRegexp).first
      end

      def migration_files
        paths = Array(Rails.root.join('db', 'data_migrate'))
        Dir[*paths.flat_map { |path| "#{path}/**/[0-9]*_*.rb" }]
      end

      def migrate(version = nil)
        # get all data migrations in data/migrations
        # get list of data migrations in database
        already_done = ActiveRecord::Base.connection.execute("SELECT version FROM data_migrations").map { |record| record['version'] }

        # all_data_migrations = Dir.entries(Rails.root.join('db', 'data_migrate')).select { |file| !File.directory?(file) }.collect{|file| file.match(/^\d+/)[0]}

        all_data_migrations =  migration_files.map do |file|
          version, name, scope = parse_migration_filename(file)
          raise IllegalMigrationNameError.new(file) unless version
          version = version.to_i
          name = name.camelize

          MigrationProxy.new(name, version, file, scope)
        end

        (all_data_migrations - already_done).each do |migration|
          require migration.filename
          (eval(migration.name).new).migrate(:up)
        end
      end
    end
  end
end

