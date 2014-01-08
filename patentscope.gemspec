# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'patentscope/version'

Gem::Specification.new do |gem|
  gem.name          = "patentscope"
  gem.version       = Patentscope::VERSION
  gem.authors       = ["Chong-Yee Khoo"]
  gem.email         = ["mail@cykhoo.com"]
  gem.description   = %q{Ruby interface to the PATENTSCOPE Web Service provided by the World Intellectual Property Organisation. Requires a subscription to the Patentscope Web Service}
  gem.summary       = %q{Ruby interface with WIPO PATENTSCOPE Web Service}
  gem.homepage      = "http://www.cantab-ip.com"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.0.0.beta1'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'webmock'

  gem.add_runtime_dependency 'nokogiri'
  gem.add_runtime_dependency 'unicode_titlecase'
end
