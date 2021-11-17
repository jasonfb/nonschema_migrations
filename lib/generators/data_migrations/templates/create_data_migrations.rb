class CreateDataMigrations < ActiveRecord::Migration[<%= Gem.loaded_specs['activerecord'].version.to_s.split(".")[0..1].join(".") %>]
  def self.up
    create_table :data_migrations, id: false do |t|
      t.string :version
    end
  end

  def self.down
    drop_table :data_migrations
  end
end
