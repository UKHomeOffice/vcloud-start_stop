# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vcloud/start_stop/version'

Gem::Specification.new do |spec|
  spec.name          = "vcloud-start_stop"
  spec.version       = Vcloud::StartStop::VERSION
  spec.authors       = ["jon-shanks"]
  spec.email         = ["jon.shanks@gmail.com"]
  spec.summary       = %q{Tool to start and stop vapps}
  spec.description   = %q{Specify the org and vapps to stop that can have a scheduled start and stop time}
  spec.homepage      = "http://github.com/jon-shanks/vcloud-start_stop"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.2'
  spec.add_runtime_dependency 'fog', '>= 1.21.0'
  spec.add_runtime_dependency 'methadone', '~> 1.8.0'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency('rdoc')
#  spec.add_development_dependency('aruba')
#  spec.add_development_dependency('cucumber')
#  spec.add_development_dependency 'gem_publisher', '1.2.0'
end
