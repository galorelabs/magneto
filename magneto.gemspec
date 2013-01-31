# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magneto/version'

Gem::Specification.new do |gem|
  gem.name          = "magneto"
  gem.version       = Magneto::VERSION
  gem.authors       = ["Matteo Parmi"]
  gem.email         = ["teo@blomming.com"]
  gem.description   = %q{A ruby wrapper around the fuzzy magento soap apis}
  gem.summary       = %q{connect to your magento installation}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'equivalent-xml'

  gem.add_runtime_dependency 'savon', '1.2.0'
  gem.add_runtime_dependency 'mustache', '0.99.4'
end
