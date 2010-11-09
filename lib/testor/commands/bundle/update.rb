require 'testor/commands/bundle'

module Testor
  class Command
    class Bundle

      class Update < Bundle

        def bundle_command
          'update'
        end

      end # class Update

    end # class Bundle
  end # class Command
end # module Testor

