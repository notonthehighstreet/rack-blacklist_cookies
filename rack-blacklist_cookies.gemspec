# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rack-blacklist_cookies"

Gem::Specification.new do |spec|
  spec.name          = "rack-blacklist_cookies"
  spec.version       = Rack::BlacklistCookies::VERSION
  spec.authors       = ["notonthehighstreet.com"]
  spec.email         = ["tech.contact@notonthehighstreet.com"]

  spec.summary       = "Blacklist cookies on the request and response HTTP headers"
  spec.description   = "Removes specified cookies from HTTP request and / or response on user defined pages."
  spec.homepage      = "https://github.com/notonthehighstreet/rack-blacklist_cookies"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "reek"
end
