$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "testor/version"

require 'rake'
FileList['tasks/**/*.rake'].each { |task| import task }

task :build do
  system "gem build testor.gemspec"
end

task :release => :build do
  system "gem push testor-#{Testor::VERSION}"
end

