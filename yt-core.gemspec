# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yt/core/version'

Gem::Specification.new do |spec|
  spec.name          = 'yt-core'
  spec.version       = Yt::Core::VERSION
  spec.authors       = ['Claudio Baccigalupo']
  spec.email         = ['claudio@fullscreen.net']
  spec.description   = %q{Youtube V3 API client.}
  spec.summary       = %q{Yt makes it easy to interact with Youtube V3 API by
    providing a modular, intuitive and tested Ruby-style API.}
  spec.homepage      = 'http://github.com/fullscreen/yt-core'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.2.2'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'yt-auth', '>= 0.2.3'
  spec.add_dependency 'yt-support', '>= 0.1.3'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'coveralls', '~> 0.8.20'
  spec.add_development_dependency 'pry-nav', '~> 0.2.4'
  spec.add_development_dependency 'jekyll', '~> 3.4'
  spec.add_development_dependency 'yard', '~> 0.9.8'
end
