# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yt/version'

Gem::Specification.new do |spec|
  spec.name          = 'yt'
  spec.version       = Yt::VERSION
  spec.authors       = ['Claudio Baccigalupo']
  spec.email         = ['claudio@fullscreen.net']
  spec.description   = %q{Youtube V3 API client.}
  spec.summary       = %q{Yt makes it easy to interact with Youtube V3 API by
    providing a modular, intuitive and tested Ruby-style API.}
  spec.homepage      = 'http://github.com/Fullscreen/yt'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
end
