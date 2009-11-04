# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra-cache}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kematzy"]
  s.date = %q{2009-11-04}
  s.description = %q{Simple Page Caching for Sinatra [www.sinatrarb.com]}
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
     "spec/fixtures/apps/base/views/index.erb",
     "spec/fixtures/apps/base/views/index.haml",
     "spec/fixtures/apps/base/views/layout.erb",
     "spec/fixtures/apps/base/views/output.erb",
     "spec/fixtures/apps/base/views/params.erb",
     "spec/sinatra/cache_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/kematzy/sinatra-cache}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Simple Page Caching for Sinatra [www.sinatrarb.com]}
  s.test_files = [
    "spec/sinatra/cache_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
