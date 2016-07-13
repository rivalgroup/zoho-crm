# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zoho-crm/version'

Gem::Specification.new do |spec|
  spec.name          = "zoho-crm"
  spec.version       = ZohoCrm::VERSION
  spec.authors       = ["Bankfacil Dev Team"]
  spec.email         = ["dev@bankfacil.com.br"]
  spec.summary       = %q{Gem to manage Zoho CRM resources API}
  spec.description   = %q{Gem to manage Zoho CRM resources API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client"
  spec.add_dependency "gyoku"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "rspec"
end
