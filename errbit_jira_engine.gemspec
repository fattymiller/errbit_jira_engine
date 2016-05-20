$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "errbit_jira_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "errbit_jira_engine"
  s.version     = ErrbitJiraEngine::VERSION
  s.authors     = ["Ben Miller"]
  s.email       = ["ben.miller@cohortsolutions.com"]
  s.homepage    = 'https://github.com/fattymiller/errbit_jira_engine'
  s.summary     = 'JIRA integration for Errbit'
  s.description = 'JIRA integration for Errbit'
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "errbit_plugin"
  s.add_dependency "jira-ruby"
  s.add_dependency "omniauth-jira"

  s.add_development_dependency "sqlite3"
end
