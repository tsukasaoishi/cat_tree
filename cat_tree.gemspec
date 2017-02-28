# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cat_tree/version'

Gem::Specification.new do |spec|
  spec.name          = "cat_tree"
  spec.version       = CatTree::VERSION
  spec.authors       = ["Tsukasa OISHI"]
  spec.email         = ["tsukasa.oishi@gmail.com"]
  spec.summary       = %q{CatTree monitors ActiveRecord objects in development environment}
  spec.description   = %q{CatTree monitors ActiveRecord objects in development environment}
  spec.homepage      = "https://github.com/tsukasaoishi/cat_tree"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1'

  spec.add_dependency 'activerecord', '>= 4.2.0', '< 5.1'

  spec.add_development_dependency "bundler", ">= 1.3.0", "< 2.0"
  spec.add_development_dependency "rake", ">= 0.8.7"
  spec.add_development_dependency 'mysql2', '~> 0.3.18'
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'appraisal'
end
