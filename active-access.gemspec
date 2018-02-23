
# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))

require "active-access/version"

Gem::Specification.new do |spec|
  spec.name          = "active-access"
  spec.version       = ActiveAccess::VERSION
  spec.required_ruby_version = [">= 2.3.0", "< 2.6.0"]
  spec.authors       = ["George J. Protacio-Karaszi"]
  spec.email         = ["georgekaraszi@gmail.com"]

  spec.summary       = "Restrict access to your Rails application by IP"
  spec.description   = "Restrict access to your Rails application by IP"
  spec.homepage      = "https://github.com/elevatorup/ActiveAccess"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ["lib"]

  spec.add_dependency("activesupport", ">= 4.2")
  spec.add_dependency("rack", ">= 1.0")

  spec.add_development_dependency("rake", "~> 10.0")
  spec.add_development_dependency("rspec", "~> 3.4")
end
