# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'testor/version'
 
Gem::Specification.new do |s|
  s.name        = 'testor'
  s.version     = Testor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Martin Gamsjaeger (snusnu)']
  s.email       = ['gamsnjaga@gmail.com']
  s.homepage    = 'http://github.com/snusnu/testor'
  s.summary     = 'Test ruby code using rvm, bundler and git'
  s.description = 'Automated testing of multiple gems against multiple rubies using bundler, rvm and git(hub)'
 
  s.required_rubygems_version = '>= 1.3.7'
  s.rubyforge_project         = 'testor'
 
  s.add_dependency 'addressable', '~> 2.2.2'
  s.add_dependency 'ruby-github', '~> 0.0.3'

  s.add_development_dependency 'rspec'
 
  s.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.require_path = 'lib'
end

