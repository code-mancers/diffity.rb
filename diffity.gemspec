$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "diffity/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "diffity"
  s.version     = Diffity::VERSION
  s.authors     = ["Yuva"]
  s.email       = ["yuva@codemancers.com"]
  s.homepage    = "http://diffity.com"
  s.summary     = "Rails integration for diffity service"
  s.description = "Rails integration for diffity service"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "Readme.md"]

  s.add_dependency "faraday"
end
