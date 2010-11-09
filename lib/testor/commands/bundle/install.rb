require 'testor/commands/bundle'

module Testor
  class Command
    class Bundle

      class Install < Bundle

        def bundle_command
          'install'
        end

      end # class Install

    end # class Bundle
  end # class Command
end # module Testor

