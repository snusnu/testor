require 'testor/commands/gem'

module Testor
  class Command
    class Gem

      class Uninstall < Gem

        def command
          "#{super} gem uninstall #{repo.name} --version #{version}"
        end

        def action
          'Uninstalling'
        end

      end # class Uninstall

    end # class Gem
  end # class Command
end # module Testor


