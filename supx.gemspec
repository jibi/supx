Gem::Specification.new {|s|
	s.name = 'supx'
	s.version = '0.0.1'
	s.author = 'jibi'
	s.email = 'jibi@paranoici.org'
	s.homepage = 'http://github.com/jibi/supx'
	s.platform = Gem::Platform::RUBY
	s.summary = 'Dump your WhatsApp conversations into cool html'
	s.description = '.'
	s.files = Dir['lib/**/*.rb']
	s.executables = ['decrypt_wa_db']

	s.add_dependency 'sequel'
}
