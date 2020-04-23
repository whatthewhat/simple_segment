# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rudder_analytics_sync/version'

Gem::Specification.new do |spec|
  spec.name          = 'rudder_analytics_sync'
  spec.version       = RudderAnalyticsSync::VERSION
  spec.authors       = ['RudderStack']
  spec.email         = ['arnab@rudderlabs.com']

  spec.summary       = 'Privacy and Security focused Segment-alternative. Ruby SDK (sync)'
  spec.description   = 'Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.'
  spec.homepage      = 'https://github.com/rudderlabs/rudder-sdk-ruby-sync'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.11'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.75.0'
  spec.add_development_dependency 'timecop', '~> 0.8.0'
  spec.add_development_dependency 'webmock', '~> 3.7'
end
