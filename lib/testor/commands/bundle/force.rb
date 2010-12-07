require 'testor/commands/bundle'

module Testor
  class Command
    class Bundle

      class Force < Command

        def command
          'rm Gemfile.*'
        end

      end # class Force

    end # class Bundle
  end # class Command
end # module Testor


