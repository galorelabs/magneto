require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "./rake/soap_fixture"

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec

task :fixture_catalog_category_tree do
  puts "Generating catalog_category_tree.xml..."
  soap_fixture = SoapFixture.new
  soap_fixture.login
  soap_fixture.make_fixture_for(:catalog_category_tree)
end
