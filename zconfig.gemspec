lib = File.expand_path("../lib", __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require "zconfig/version"

Gem::Specification.new do |s|
  s.name     = "zconfig"
  s.version  = ZConfig::VERSION
  s.authors  = ["Richard Jones"]
  s.email    = "itszootime@gmail.com"
  s.summary  = %q{A library for accessing ZConfig-managed configurations within Ruby}
  s.homepage = "https://github.com/itszootime/zconfig-ruby"
  s.license  = "MIT"
  s.has_rdoc = "yard"

  s.files = Dir["lib/**/*"] + %w{.yardopts LICENSE README.md zconfig.gemspec}
  s.test_files = Dir["spec/**/*"]
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 3.4"
end
