require 'testor/commands/gem'

module Testor
  class Command
    class Gem

      class Install < Gem

        def command
          "#{super} gem build #{gemspec_file}; #{super} gem install #{gem}"
        end

        def action
          'Installing'
        end

      end # class Install

    end # class Gem
  end # class Command
end # module Testor

