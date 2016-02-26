require './lib/cpr_client/version'

Gem::Specification.new do |s|
  s.name        = 'cpr-client'
  s.version     = CPRClient::VERSION
  s.date        = '2016-02-26'
  s.summary     = 'CPR Client'
  s.description = 'Client for making requests to the CPR registry (as a private company)'
  s.authors     = ['Michael Andersen']
  s.email       = 'michael@aion.dk'
  s.homepage    = 'http://assemblyvoting.dk'
  s.files       = Dir.glob('lib/**/*') + %w(README.md)
  s.license     = 'MIT'

  s.add_development_dependency 'rake', '~> 10.5'
  s.add_development_dependency 'minitest', '~> 5.8'

  s.add_runtime_dependency 'nokogiri', '~> 1.6'
  s.add_runtime_dependency 'httpclient', '~> 2.7'

end