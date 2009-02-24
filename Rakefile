require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "sinatra-cache"
    s.summary = %Q{Simple Page Caching for Sinatra [www.sinatrarb.com]}
    s.email = "kematzy@gmail.com"
    s.homepage = "http://github.com/kematzy/sinatra-cache"
    s.description = "Simple Page Caching for Sinatra [www.sinatrarb.com]"
    s.authors = ["kematzy"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'sinatra-cache'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

# begin
#   require 'rcov/rcovtask'
#   Rcov::RcovTask.new do |t|
#     t.libs << 'test'
#     t.test_files = FileList['test/**/*_test.rb']
#     t.verbose = true
#   end
# rescue LoadError
#   puts "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
# end
# 

task :default => :test
