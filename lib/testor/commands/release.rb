require 'testor/command'

module Testor
  class Command

    class Release < Command

      def run
        # TODO move to its own command
        clean_repository(project_name)

        FileUtils.cd(working_dir) do
          log(command)
          system(command) unless pretend?
        end
      end

      def command
        'rake release'
      end

      def action
        'Releasing'
      end

    end # class Release
  end # class Command
end # module Testor

