require 'pathname'

module Testor

  class Environment

    attr_reader :name
    attr_reader :options
    attr_reader :root
    attr_reader :included
    attr_reader :excluded
    attr_reader :rubies
    attr_reader :bundle_root
    attr_reader :gemset
    attr_reader :command_options

    def initialize(name, options)
      @name            = name
      @options         = options
      @root            = Pathname(@options[:root       ] ||  ENV['DM_DEV_ROOT'       ] || Dir.pwd)
      @bundle_root     = Pathname(@options[:bundle_root] ||  ENV['DM_DEV_BUNDLE_ROOT'] || @root.join(default_bundle_root))
      @included        = @options[:include             ] || (ENV['INCLUDE'           ]  ? normalize(ENV['INCLUDE']) : default_included)
      @excluded        = @options[:exclude             ] || (ENV['EXCLUDE'           ]  ? normalize(ENV['EXCLUDE']) : default_excluded)
      @rubies          = @options[:rubies              ] || (ENV['RUBIES'            ]  ? normalize(ENV['RUBIES' ]) : default_rubies)
      @verbose         = @options[:verbose             ] || (ENV['VERBOSE'           ] == 'true')
      @silent          = @options[:silent              ] || (ENV['SILENT'            ] == 'true')
      @pretend         = @options[:pretend             ] || (ENV['PRETEND'           ] == 'true')
      @benchmark       = @options[:benchmark           ] || (ENV['BENCHMARK'         ] == 'true')
      @gemset          = @options[:gemset              ] ||  ENV['GEMSET'            ]
      @command_options = @options[:command_options     ] ||  nil
    end

    def default_bundle_root
      'TESTOR_BUNDLE_ROOT'
    end

    def default_included
      nil # means all
    end

    def default_excluded
      [] # overwrite in subclasses
    end

    def default_rubies
      %w[ 1.8.7 1.9.2 jruby rbx ]
    end

    def verbose?
      @verbose
    end

    def silent?
      @silent
    end

    def pretend?
      @pretend
    end

    def benchmark?
      @benchmark
    end

  private

    def normalize(string)
      string.gsub(',', ' ').split(' ')
    end

  end # class Environment
end # module Testor

