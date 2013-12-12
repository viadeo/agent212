require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec


gem_spec = eval(File.read('agent212.gemspec'))
Rake::GemPackageTask.new(gem_spec) do |pkg|
  pkg.need_tar_bz2 = true
  pkg.need_zip = true
  pkg.need_tar = true
end

