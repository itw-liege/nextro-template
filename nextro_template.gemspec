# frozen_string_literal: true

require_relative "lib/nextro_template/version"

Gem::Specification.new do |spec|
  spec.name = "nextro_template"
  spec.version = NextroTemplate::VERSION
  spec.authors = ["ITW"]
  spec.email = ["info@intotheweb.be"]

  spec.summary = "Nextro admin template - Design complet pour back-office Rails"
  spec.description = "Gem complète incluant le template Nextro (Bootstrap), layout admin, concerns CRUD, helpers, générateurs et assets."
  spec.homepage = "https://github.com/example/nextro_template"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,doc,lib}/**/*", ".gitignore", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 6.0"
  spec.add_dependency "breadcrumbs_on_rails"
  spec.add_dependency "bootstrap", "~> 4.0"
  spec.add_dependency "bootstrap_form", "~> 4.0"
  spec.add_dependency "sassc-rails"

  spec.add_development_dependency "sqlite3"
end
