Gem::Specification.new {|s|
	s.name        = 'supx'
	s.version     = '0.0.2'
  s.licenses    = ['WTFPL', 'MIT']
	s.author      = 'jibi'
	s.email       = 'jibi@paranoici.org'
	s.homepage    = 'http://github.com/jibi/supx'
	s.platform    = Gem::Platform::RUBY
	s.summary     = 'Dump your WhatsApp conversations into cool html'
	s.description = '.'
	s.files       = Dir['lib/**/*.rb'] + Dir['public/**/*'] + Dir['views/*']
	s.executables = ['supx', 'supx_dumper']

	s.add_dependency 'sequel', '4.10', '>= 4.10.0'
}

