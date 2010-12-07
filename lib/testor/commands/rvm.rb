require 'testor/command'

module Testor
  class Command

    class Rvm < Command

      attr_reader :rubies

      def initialize(repo, env, logger)
        super
        @rubies = env.rubies
      end

      def command
        "rvm #{rubies.join(',')}"
      end

      class Exec < Rvm

        attr_reader :ruby

        def run
          super do
            rubies.each do |ruby|
              @ruby = ruby
              if block_given?
                yield(ruby)
              else
                execute
              end
            end
          end
        end

      private

        def command
          "rvm #{@ruby} exec bash -c"
        end

        def action
          "[#{@ruby}]"
        end

      end # class Exec

    end # class Rvm
  end # class Command
end # module Testor

