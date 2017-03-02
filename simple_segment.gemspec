# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_segment/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_segment'
  spec.version       = SimpleSegment::VERSION
  spec.authors       = ['Mikhail Topolskiy']
  spec.email         = ['mikhail.topolskiy@gmail.com']

  spec.summary       = 'A simple synchronous API client for segment.io.'
  spec.description   = 'SimpleSegment allows for manual control of when and how the events are sent to Segment.'
  spec.homepage      = 'https://github.com/whatthewhat/simple_segment'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 1.24'
  spec.add_development_dependency 'timecop', '~> 0.8.0'
  spec.add_development_dependency 'rubocop', '~> 0.47.0'
  spec.add_development_dependency 'pry'
end
