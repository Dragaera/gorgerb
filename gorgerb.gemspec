# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'gorgerb'
  spec.version       = '0.2.0'
  spec.authors       = ['Michael Senn']
  spec.email         = ['michael@morrolan.ch']

  spec.summary       = %q{Ruby binding to Gorge, the NS2+/Wonitor stats aggregator.}
  # spec.description   = %q{}
  spec.homepage      = "https://github.com/Dragaera/gorgerb"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'typhoeus', '~> 1.3'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'pry', '~> 0.11'
end


