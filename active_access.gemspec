
# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require "active_access/version"

Gem::Specification.new do |spec|
  spec.name          = "active_access"
  spec.version       = ActiveAccess::VERSION
  s.required_ruby_version = [">= 2.3.0", "< 2.6.0"]
  spec.authors       = ["George J. Protacio-Karaszi"]
  spec.email         = ["georgekaraszi@gmail.com"]

  spec.summary       = "Restrict access to your application by IP"
  spec.description   = "Restrict access to your application by IP"
  spec.homepage      = "https://github.com/GeorgeKaraszi/ActiveAccess"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
end