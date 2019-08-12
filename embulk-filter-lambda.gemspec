
Gem::Specification.new do |spec|
  spec.name          = "embulk-filter-lambda"
  spec.version       = "0.1.0"
  spec.authors       = ["giwa"]
  spec.summary       = "Lambda filter plugin for Embulk"
  spec.description   = "Lambda"
  spec.email         = ["ugw.gi.world@gmail.com"]
  spec.licenses      = ["MIT"]
  # TODO set this: spec.homepage      = "https://github.com/ugw.gi.world/embulk-filter-lambda"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  #spec.add_dependency 'YOUR_GEM_DEPENDENCY', ['~> YOUR_GEM_DEPENDENCY_VERSION']
  spec.add_development_dependency 'aws-sdk', ['>= 3.0.1']
  spec.add_development_dependency 'jsonpath', ['>= 1.0.4']
  spec.add_development_dependency 'embulk', ['>= 0.9.12']
  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'rake', ['>= 10.0']
end
