# -*- encoding: utf-8 -*-
require File.expand_path('../lib/licit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Juan Wajnerman"]
  gem.email         = ["jwajnerman@manas.com.ar"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "licit"
  gem.require_paths = ["lib"]
  gem.version       = Licit::VERSION
  gem.add_development_dependency 'rspec'
end
