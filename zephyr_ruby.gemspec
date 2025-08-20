# frozen_string_literal: true

require_relative 'lib/zephyr_ruby/version'

Gem::Specification.new do |spec|
  spec.name    = 'zephyr_ruby'
  spec.version = ZephyrRuby::VERSION
  spec.authors = ['Chris Davis']

  spec.summary     = 'Zephyr REST API Client and CLI for Ruby'
  spec.description = "Allows users to use Zephyr's REST API and provides a command-line interface"
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 3.0'
  spec.homepage = 'https://github.com/cdavis-personal/zephyr_ruby'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || 
      f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)}) ||
      f.end_with?(".gem")
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 1.7', '>= 1.7.0'
  spec.add_dependency 'json', '~> 2.3', '>= 2.3.0'
  spec.add_dependency 'rspec', '~> 3.7', '>= 3.7.0'
  spec.add_dependency 'thor', '~> 1.0'
  spec.add_dependency 'nokogiri', '~> 1.12'
end
