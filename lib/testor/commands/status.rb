require 'testor/command'

module Testor
  class Command

    class Status < Command

      def run
        log "cd #{working_dir}" if verbose? || pretend?
        FileUtils.cd(working_dir) do
          log    command
          system command unless pretend?
        end
      end

      def command
        "git status"
      end

      def action
        'git status'
      end

    end # class Status
  end # class Command
end # module Testor

