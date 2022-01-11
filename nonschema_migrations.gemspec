require "./lib/nonschema_migrations/version"

Gem::Specification.new do |s|
  s.name        = 'nonschema_migrations'
  s.version     = NonSchemaMigrations::VERSION
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.summary     = "Nonschema(data-only) migrations for your Rails app"
  s.description = "Separate schema-only migrations from nonschema (data) migrations in your Rails app"
  s.authors     = ["Jason Fleetwood-Boldt"]
  s.email       = 'code@jasonfb.net'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)}) || f.match(%r{(gemspec|gem)$}) }
    files
  end
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

    For support please see https://heliosdev.shop/
    ---------------------------------------------
  MSG


  spec.add_runtime_dependency "rails",  '> 5.1'
end