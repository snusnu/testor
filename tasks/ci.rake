desc 'Heckle and run metrics'
task :ci => [ :heckle, :flog, :flay, :reek, :roodi]

desc 'Run metrics'
task :metrics => [ :flog, :flay, :reek, :roodi]

