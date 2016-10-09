# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman-citation/version'

Gem::Specification.new do |spec|
  spec.name          = "middleman-citation"
  spec.version       = Middleman::Citation::VERSION
  spec.authors       = ["Thomas Torsney-Weir"]
  spec.email         = ["torsneyt@gmail.com"]
  spec.description   = <<-EOF 
                       A middleman extension that gives helpers for
                       creating citations using citeproc
                       EOF
  spec.summary       = %q{Middleman extension for citeproc}
  spec.homepage      = "https://github.com/gabysbrain/middleman-citation"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bibtex-ruby"
  spec.add_runtime_dependency "citeproc-ruby"
  spec.add_runtime_dependency "csl-styles"
  spec.add_runtime_dependency "middleman-core", ["~> 4"]
end
