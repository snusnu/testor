require 'fileutils'

module Testor

  class Command

    attr_reader :repo
    attr_reader :env
    attr_reader :root
    attr_reader :path
    attr_reader :uri
    attr_reader :logger
    attr_reader :results
    attr_reader :output

    def initialize(repo, env, logger)
      @repo    = repo
      @env     = env
      @root    = @env.root
      @path    = @root.join(@repo.name)
      @uri     = @repo.uri
      @logger  = logger
      @verbose = @env.verbose?
      @results = []
    end

    def before
      # overwrite in subclasses
    end

    def run
      log_directory_change
      FileUtils.cd(working_dir) do
        if block_given?
          yield
        else
          execute
        end
      end
      results
    end

    def after
      # overwrite in subclasses
    end

    def execute
      if executable?
        before
        unless suppress_log? || skip?
          log(command)
        end
        unless pretend?
          sleep(timeout)
          shell(command) unless skip?
          @results << { :status => status, :output => output }
        end
        after
      else
        if verbose? && !pretend?
          log(command, "SKIPPED! - #{explanation}")
        end
      end
    end

    def skip?
      false
    end

    def status
      if skip?
        :skipped
      else
        $? && $?.success? ? :pass : :fail
      end
    end

    # overwrite in subclasses
    def command
      raise NotImplementedError
    end

    # overwrite in subclasses
    def executable?
      true
    end

    # overwrite in subclasses
    def suppress_log?
      false
    end

    # overwrite in subclasses
    def explanation
      'reason unknown'
    end

    def log_directory_change
      if needs_directory_change? && (verbose? || pretend?)
        log "cd #{working_dir}"
      end
    end

    def needs_directory_change?
      Dir.pwd != working_dir.to_s
    end

    def ignored?
      ignored_repos.include?(repo.name)
    end

    # overwrite in subclasses
    def ignored_repos
      []
    end

    # overwrite in subclasses
    def working_dir
      path
    end

    def verbose?
      @verbose
    end

    def pretend?
      @env.pretend?
    end

    def collect_output?
      env.collect_output?
    end

    def verbosity
      verbose? ? verbose : silent
    end

    # overwrite in subclasses
    def verbose
    end

    def silent
       ' > /dev/null 2>&1'
    end

    # overwrite in subclasses
    def timeout
      0
    end

    # overwrite in subclasses
    def action
    end

    def log(command = nil, msg = nil)
      logger.log(repo, action, command, msg)
    end

    def shell(command)
      if collect_output?
        @output = %x[#{command}]
      else
        system(command)
      end
    end

  end # class Command
end # module Testor

