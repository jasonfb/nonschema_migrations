Gem::Specification.new do |s|
  s.name        = 'nonschema_migrations'
  s.version     = '0.0.0'
  s.date        = '2019-03-17'
  s.summary     = "Nonschema(data-only) migrations for your Rails app"
  s.description = "Separate schema-only migrations from nonschema (data) migrations in your Rails app"
  s.authors     = ["Jason Fleetwood-Boldt"]
  s.email       = 'jason.fb@datatravels.com'
  s.files       = ["lib/generators/data_migration_install_generator.rb",
                   "lib/generators/data_migration_generator.rb",
                   "lib/nondestructive_migrator.rb",
                   "lib/nondestructive_migrations.rb",
                   "lib/generators/templates/create_data_migrations.rb",
                   "lib/nondestructive_migrations/railtie.rb",
                   "lib/tasks/data.rb"]
  s.homepage    =  'https://github.com/jasonfb/nonschema_migrations'
  s.license       = 'MIT'
  
  s.add_runtime_dependency 'activerecord'
end