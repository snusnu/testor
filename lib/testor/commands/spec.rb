require 'testor/commands/bundle'

module Testor
  class Command

    class Spec < Bundle

      def run

        if print_matrix?
          puts  "\nh2. %s\n\n"   % repo.name
          puts  '| RUBY  | %s |' % env.adapters(repo).join(' | ')
        end

        super do |ruby|

          print '| %s |' % ruby if print_matrix?

          if block_given?

            yield ruby

          else

            execute

            if print_matrix?
              print ' %s |' % [ $?.success? ? 'pass' : 'fail' ]
            end

          end

        end

      end

      def bundle_command
        if env.command_options
          "exec spec #{env.command_options.join(' ')}"
        else
          'exec rake spec'
        end
      end

      def action
        "#{super} Testing"
      end

      def print_matrix?
        executable? && !verbose? && !pretend?
      end

      def suppress_log?
        !executable? || print_matrix?
      end

    end # class Spec
  end # class Command
end # module Testor

