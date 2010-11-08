require 'testor/command'

module Testor
  class Command

    class Sync < Command

      def self.new(repo, env, logger)
        return super unless self == Sync
        if env.root.join(repo.name).directory?
          Pull.new(repo, env, logger)
        else
          Clone.new(repo, env, logger)
        end
      end

      class Clone < Sync

        def initialize(repo, env, logger)
          super
          @git_uri        = uri.dup
          @git_uri.scheme = 'git'
          if env.options[:development]
            @git_uri.to_s.sub!('://', '@').sub!('/', ':')
          end
        end

        def command
          "git clone #{@git_uri}.git #{verbosity}"
        end

        def working_dir
          root
        end

        def action
          'Cloning'
        end

      end # class Clone

      class Pull < Sync

        def command
          "git checkout master #{verbosity}; git pull --rebase #{verbosity}"
        end

        def action
          'Pulling'
        end

      end # class Pull

    end # class Sync
  end # class Command
end # module Testor

