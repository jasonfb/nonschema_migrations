require "./lib/nonschema_migrations/version"

Gem::Specification.new do |s|
  s.name        = 'nonschema_migrations'
  s.version     = NonSchemaMigrations::VERSION
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.summary     = "Nonschema(data-only) migrations for your Rails app"
  s.description = "Separate schema-only migrations from nonschema (data) migrations in your Rails app"
  s.authors     = ["Jason Fleetwood-Boldt"]
  s.email       = 'code@jasonfb.net'
  s.files       = ["lib/generators/data_migrations/install_generator.rb",
                   "lib/generators/data_migration_generator.rb",
                   "lib/active_record/data_migration.rb",
                   "lib/nonschema_migrator.rb",
                   "lib/nonschema_migrations.rb",
                   "lib/generators/data_migrations/templates/create_data_migrations.rb",
                   "lib/nonschema_migrations/railtie.rb",
                   "lib/tasks/data.rb"]
  s.homepage    =  'https://github.com/jasonfb/nonschema_migrations'

  s.metadata    = { "source_code_uri" => "https://github.com/jasonfb/nonschema_migrations",
                       "documentation_uri" => "https://jasonfleetwoodboldt.com/my-open-source-projects/nonschema-migrations/",
                       "homepage_uri" => 'https://heliosdev.shop/'}

  s.license       = 'MIT'
  s.post_install_message = <<~MSG
    ---------------------------------------------
    Welcome to Nonschema Migrations
    to set up, please run
    
    rails generate data_migrations:install

    For support please check us out at https://heliosdev.shop/
    ---------------------------------------------
  MSG

  s.add_runtime_dependency 'activerecord', ["= 7.0.0.alpha2"]
end