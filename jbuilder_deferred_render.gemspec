# coding: utf-8
lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$LOAD_PATH.unshift("/home/ec2-user/gitrepos/deferred_loader/lib")
$LOAD_PATH.unshift("/home/ec2-user/gitrepos/jbuilder_deferred_render/vendor/bundle/ruby/2.1.0/gems")
require 'jbuilder_deferred_render/version'

Gem::Specification.new do |spec|
  spec.name          = "jbuilder_deferred_render"
  spec.version       = JbuilderDeferredRender::VERSION
  spec.authors       = ["maedama"]
  spec.email         = ["maedama85@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_dependency "rails", "~> 4.1"
  spec.add_dependency "jbuilder"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sqlite3", "~> 1.3.10"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "json_spec"
  spec.add_dependency "q-defer", "~> 0.0.1"
  

end
