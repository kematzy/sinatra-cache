# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra-cache}
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kematzy"]
  s.date = %q{2010-04-27}
  s.description = %q{A Sinatra Extension that makes Page and Fragment Caching easy.}
  s.email = %q{kematzy@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/sinatra/cache.rb",
     "lib/sinatra/cache/helpers.rb",
     "lib/sinatra/templates.rb",
     "sinatra-cache.gemspec",
     "spec/fixtures/apps/base/views/css.sass",
     "spec/fixtures/apps/base/views/fragments.erb",
     "spec/fixtures/apps/base/views/fragments_shared.erb",
     "spec/fixtures/apps/base/views/index.erb",
     "spec/fixtures/apps/base/views/layout.erb",
     "spec/fixtures/apps/base/views/params.erb",
     "spec/sinatra/cache_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/kematzy/sinatra-cache}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A Sinatra Extension that makes Page and Fragment Caching easy.}
  s.test_files = [
    "spec/sinatra/cache_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 1.0.a"])
      s.add_runtime_dependency(%q<sinatra-outputbuffer>, [">= 0.1.0"])
      s.add_development_dependency(%q<sinatra-tests>, [">= 0.1.6"])
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
    else
      s.add_dependency(%q<sinatra>, [">= 1.0.a"])
      s.add_dependency(%q<sinatra-outputbuffer>, [">= 0.1.0"])
      s.add_dependency(%q<sinatra-tests>, [">= 0.1.6"])
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 1.0.a"])
    s.add_dependency(%q<sinatra-outputbuffer>, [">= 0.1.0"])
    s.add_dependency(%q<sinatra-tests>, [">= 0.1.6"])
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
  end
end

