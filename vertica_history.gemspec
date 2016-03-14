$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "vertica_history/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "vertica_history"
  s.version     = VerticaHistory::VERSION
  s.authors     = ["David Taylor"]
  s.email       = ["djtaylor333@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "Gem to connect rails admin to Vertica to see history of any record"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4"
  s.add_dependency "rails_admin", "~> 0.7"

  s.add_development_dependency "sqlite3"
end
