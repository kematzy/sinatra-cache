# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra-cache}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kematzy"]
  s.date = %q{2009-02-25}
  s.description = %q{Simple Page Caching for Sinatra [www.sinatrarb.com]}
  s.email = %q{kematzy@gmail.com}
  s.files = ["README.textile", "VERSION.yml", "lib/sinatra", "lib/sinatra/cache.rb", "test/cache_test.rb", "test/fixtures", "test/fixtures/classic.rb", "test/fixtures/myapp.rb", "test/fixtures/myapp_default.rb", "test/fixtures/public", "test/fixtures/views", "test/fixtures/views/index.erb", "test/helper.rb", "test/SPECS.rdoc"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/kematzy/sinatra-cache}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple Page Caching for Sinatra [www.sinatrarb.com]}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
