require 'active_record/scoping/default'
require 'active_record/scoping/named'
require 'active_record/base'

module ActiveRecord
  class DataMigration < ActiveRecord::Base
    def initialize(migrations)

      @migration_struct = migrations
    end


    def up
      Migrator.new(:up, @migration_struct).migrate
    end

    def down
      Migrator.new(:down, @migration_struct).migrate
    end


    class << self
      def primary_key
        nil
      end

      def table_name
        "#{table_name_prefix}data_migrations#{table_name_suffix}"
      end

      def index_name
        "#{table_name_prefix}unique_data_migrations#{table_name_suffix}"
      end

      def table_exists?
        connection.table_exists?(table_name)
      end

      def create_table(limit=nil)
        unless table_exists?
          version_options = {null: false}
          version_options[:limit] = limit if limit

          connection.create_table(table_name, id: false) do |t|
            t.column :version, :string, version_options
          end
          connection.add_index table_name, :version, unique: true, name: index_name
        end
      end

      def drop_table
        if table_exists?
          connection.remove_index table_name, name: index_name
          connection.drop_table(table_name)
        end
      end

      def normalize_migration_number(number)
        "%.3d" % number.to_i
      end
    end

    def version
      super.to_i
    end
  end
end
