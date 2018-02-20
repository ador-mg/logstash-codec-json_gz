Gem::Specification.new do |s|

  s.name          = 'logstash-codec-json_gz'
  s.version       = '0.1.5'
  s.licenses        = ['Apache-2.0']
  s.summary       = 'Handle gzipped json input for logstash.'
  s.description   = 'This logstash codec reads gzipped json data from the input and on faiure falls back to the plain codec'
  s.homepage      = 'https://github.com/ador-mg/logstash-codec-json_gz'
  s.authors       = ['Antonis Mygiakis']
  s.email         = 'a.migiakis@clmsuk.com'
  s.require_paths = ['lib']

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "codec" }

  # Gem dependencies
  s.add_runtime_dependency 'logstash-core-plugin-api', "~> 2.0"
  s.add_runtime_dependency 'logstash-codec-plain'

  s.add_development_dependency 'logstash-devutils'
end

