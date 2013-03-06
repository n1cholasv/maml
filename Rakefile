require 'rubygems'
require 'rake'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "maml"
    gemspec.summary = "Migration Apathy Markup Language"
    gemspec.description = "MAML, also know as LazyMAML is a terser means for initially modeling your rails app. The MAML yml file is processed, and the rails migration generator called, with arguments being passed through for scaffold, model, controller, haml, etc. as desired."
    gemspec.email = "vanweerd@gmail.com"
    gemspec.homepage = "http://github.com/vanweerd/maml"
    gemspec.authors = ["Nick Van Weerdenburg"]
    gemspec.files.include %w(lib/maml/maml.yml)
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each{|ext| load ext}

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
