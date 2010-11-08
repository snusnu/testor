module Testor

  class Logger

    attr_reader :progress

    def initialize(env, repo_count)
      @env      = env
      @progress = 0
      @total    = repo_count
      @padding  = @total.to_s.length
      @verbose  = @env.verbose?
      @pretend  = @env.pretend?
    end

    def log(repo, action, command = nil, msg = nil)
      return if @env.silent?
      command = command.to_s.squeeze(' ').strip # TODO also do for actually executed commands
      if @pretend || @verbose
        puts command
      else
        puts '[%0*d/%d] %s %s %s%s' % format(repo, action, command, msg)
      end
    end

    def progress!
      @progress += 1
    end

    def format(repo, action, command, msg)
      [ @padding, @progress, @total, action, repo.name, msg, @verbose ? ": #{command}" : '' ]
    end

  end # class Logger
end # module Testor

