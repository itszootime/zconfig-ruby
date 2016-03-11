$:.unshift(File.expand_path("../lib", __FILE__))
require "zconfig/version"

Gem::Specification.new do |spec|
  spec.name     = "zconfig"
  spec.version  = ZConfig::VERSION
  spec.authors  = ["Richard Jones"]
  spec.email    = "itszootime@gmail.com"
  spec.summary  = %q{A client for (re)loading ZConfig-managed configurations}
  spec.homepage = "https://github.com/itszootime/zconfig-ruby"
  spec.license  = "MIT"

  spec.files = Dir.glob("lib/**/*") + %w{README.md}
  spec.test_files = Dir.glob("spec/**/*")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.4"
end
