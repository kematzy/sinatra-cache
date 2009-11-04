require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sinatra-cache"
    gem.summary = %Q{Simple Page Caching for Sinatra [www.sinatrarb.com]}
    gem.description = %Q{Simple Page Caching for Sinatra [www.sinatrarb.com]}
    gem.email = "kematzy@gmail.com"
    gem.homepage = "http://github.com/kematzy/sinatra-cache"
    gem.authors = ["kematzy"]
    # gem.add_dependency('dependency', '>=x.x.x')
    gem.add_development_dependency("rspec")
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_opts = ["--color", "--format", "specdoc", "--require", "spec/spec_helper.rb"]  
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_opts = ["--color", "--format", "specdoc", "--require", "spec/spec_helper.rb"]
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? IO.read('VERSION').chomp : "[Unknown]"
  
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Sinatra::Cache v#{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Build the rdoc HTML Files'
task :docs do
  version = File.exist?('VERSION') ? IO.read('VERSION').chomp : "[Unknown]"
    
  sh "sdoc -N --title 'Sinatra::Cache v#{version}' lib/"
end

namespace :docs do
  
  desc 'Remove rdoc products'
  task :remove => [:clobber_rdoc]
  
  desc 'Force a rebuild of the RDOC files'
  task :rebuild => [:rerdoc]
  
  desc 'Build docs, and open in browser for viewing (specify BROWSER)'
  task :open => [:docs] do
    browser = ENV["BROWSER"] || "safari"
    sh "open -a #{browser} doc/index.html"
  end
  
end


namespace :cache do
  
  desc "Create the cache directories. path=public/system/cache"
  task :dirs, [:path] do |t, args|
    unless args.path
      msg = %Q[\nERROR:\n\n  You must define the :path variable like this:\n]
      msg << %Q[  rake cache:dirs path=public/system/cache \n\n]
      puts msg
    else
      puts "mkdir -p #{args.path}"
      # sh "mkdir -p #{args.path}"
      # sh "mkdir -p #{args.path}/fragments"
    end
  end
  
end #/ namespace cache
