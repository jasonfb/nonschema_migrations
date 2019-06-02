Gem::Specification.new do |s|
  s.name        = 'nonschema_migrations'
  s.version     = '4.0.2'
  s.date        = '2019-06-02'
  s.summary     = "Nonschema(data-only) migrations for your Rails app"
  s.description = "Separate schema-only migrations from nonschema (data) migrations in your Rails app"
  s.authors     = ["Jason Fleetwood-Boldt"]
  s.email       = 'jason.fb@datatravels.com'
  s.files       = ["lib/generators/data_migrations/install_generator.rb",
                   "lib/generators/data_migration_generator.rb",
                   "lib/active_record/data_migration.rb",
                   "lib/nonschema_migrator.rb",
                   "lib/nonschema_migrations.rb",
                   "lib/generators/data_migrations/templates/create_data_migrations.rb",
                   "lib/nonschema_migrations/railtie.rb",
                   "lib/tasks/data.rb"]
  s.homepage    =  'https://github.com/jasonfb/nonschema_migrations'
  s.license       = 'MIT'
  
  s.add_runtime_dependency 'activerecord', '~> 5.2'
end