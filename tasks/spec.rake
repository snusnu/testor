spec_defaults = lambda do |spec|
  spec.pattern    = 'spec/**/*_spec.rb'
  spec.libs      << 'lib' << 'spec'
  spec.spec_opts << '--options' << 'spec/spec.opts'
end

begin
  require 'spec/rake/spectask'

  Spec::Rake::SpecTask.new(:spec, &spec_defaults)
rescue LoadError
  task :spec do
    abort 'rspec is not available. In order to run spec, you must: gem install rspec'
  end
end

begin
  require 'rcov'
  require 'spec/rake/verify_rcov'

  Spec::Rake::SpecTask.new(:rcov) do |rcov|
    spec_defaults.call(rcov)
    rcov.rcov      = true
    rcov.rcov_opts = File.read('spec/rcov.opts').split(/\s+/)
  end

  config    = YAML.load_file(File.expand_path('../../config/rcov.yml', __FILE__)).freeze
  threshold = config.fetch('threshold').to_f

  RCov::VerifyTask.new(:verify_rcov => :rcov) do |rcov|
    rcov.threshold = threshold
  end
rescue LoadError
  %w[ rcov verify_rcov ].each do |name|
    task name do
      abort "rcov is not available. In order to run #{name}, you must: gem install rcov"
    end
  end
end

task :default => :spec
