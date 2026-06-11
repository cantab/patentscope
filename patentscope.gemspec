# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'patentscope/version'

Gem::Specification.new do |spec|
  spec.name          = "patentscope"
  spec.version       = Patentscope::VERSION
  spec.licenses      = "MIT"
  spec.authors       = ["Chong-Yee Khoo"]
  spec.email         = ["mail@cykhoo.com"]

  spec.summary       = %q{Ruby interface with WIPO PATENTSCOPE Web Service}
  spec.description   = %q{Ruby interface to the PATENTSCOPE Web Service provided by the World Intellectual Property Organisation. Requires a subscription to the Patentscope Web Service}
  spec.homepage      = "http://www.cantab-ip.com"
  spec.required_ruby_version = ">= 4.0.5"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'dotenv', '>= 3.0'
  spec.add_development_dependency 'rake', '>= 13.0'
  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'vcr', '~> 6.0'
  spec.add_development_dependency 'webmock', '~> 3.0'

  spec.add_runtime_dependency 'nokogiri', '>= 1.15'
end
