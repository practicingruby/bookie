require "#{File.dirname(__FILE__)}/lib/bookie/version"
 
Gem::Specification.new do |s|
  s.name        = "bookie"
  s.version     = Bookie::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Gregory Brown"]
  s.email       = ["gregory.t.brown@gmail.com"]
  s.homepage    = "http://github.com/sandal/bookie"
  s.summary     = "Experiment in pure ruby ebook generation tooling"
  s.description = "Eventually this may be a markdown to PDF, ePUB, MOBI "+
                  "processor. For now it's just something I'm playing "+
                  "around with, so use at your own risk"
 
  s.add_dependency('prawn', '~> 0.11.0')
  s.add_dependency('eeepub', '~> 0.6.0')

  s.files        = Dir.glob("{lib,test,examples,doc,data}/**/*") + %w(GPLv3 README.md CHANGELOG.md)
  s.require_path = 'lib'
  s.required_ruby_version = ">= 1.9.2"
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "bookie"
end

