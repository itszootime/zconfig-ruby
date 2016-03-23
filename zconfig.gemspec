lib = File.expand_path("../lib", __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require "zconfig/version"

Gem::Specification.new do |s|
  s.name     = "zconfig"
  s.version  = ZConfig::VERSION
  s.authors  = ["Richard Jones"]
  s.email    = "itszootime@gmail.com"
  s.summary  = %q{A client for (re)loading ZConfig-managed configurations}
  s.homepage = "https://github.com/itszootime/zconfig-ruby"
  s.license  = "MIT"

  s.files = Dir["lib/**/*"] + %w{README.md}
  s.test_files = Dir["spec/**/*"]
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 3.4"
end
