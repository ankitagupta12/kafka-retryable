# frozen_string_literal: true
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kafka/retryable/version'

Gem::Specification.new do |spec|
  spec.name          = 'kafka-retryable'
  spec.version       = Kafka::Retryable::VERSION
  spec.authors       = ['Ankita Gupta']
  spec.email         = ['ankita@indydevs.org']

  spec.summary       = 'Allows defining failure handling strategy for Kafka consumers'
  spec.description   = 'Allws specifying different failure handling in case of consumer failures'
  spec.homepage      = 'https://github.com/ankitagupta12/kafka-retryable'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-configurable', '~> 0.7'
  spec.add_dependency 'dry-validation', '~> 0.11'
  spec.add_dependency 'waterdrop', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.15'
end
