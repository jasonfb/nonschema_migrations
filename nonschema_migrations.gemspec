require "./lib/nonschema_migrations/version"

Gem::Specification.new do |spec|
  spec.name        = 'nonschema_migrations'
  spec.version     = NonSchemaMigrations::VERSION
  spec.date        = Time.now.strftime("%Y-%m-%d")
  spec.summary     = "Nonschema(data-only) migrations for your Rails app"
  spec.description = "Separate schema-only migrations from nonschema (data) migrations in your Rails app"
  spec.authors     = ["Jason Fleetwood-Boldt"]
  spec.email       = 'code@jasonfb.net'


  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)}) || f.match(%r{(gemspec|gem)$}) }
    files
  end

  spec.homepage    =  'https://github.com/jasonfb/nonschema_migrations'

  spec.metadata    = { "source_code_uri" => "https://github.com/jasonfb/nonschema_migrations",
                       "documentation_uri" => "https://jasonfleetwoodboldt.com/my-open-source-projects/nonschema-migrations/",
                       "homepage_uri" => 'https://heliosdev.shop/'}

  spec.license       = 'MIT'
  spec.post_install_message = <<~MSG
    ---------------------------------------------
    Welcome to Nonschema Migrations

    1. run set up data migrations:
    rails generate data_migrations:install
    2. to create a data migration use
    rails generate data_migration SetupExampleData

    You can think of data migrations like seed data for production, staging, and dev environments. 

    For support please see https://heliosdev.shop/
    ---------------------------------------------
  MSG


  spec.add_runtime_dependency "rails", ">= 7.0", "<= 8.1"
end
