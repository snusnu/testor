require 'testor/commands/rvm'

module Testor
  class Command

    class Gem < Rvm

      def before
        create_gemset = "rvm gemset create #{env.gemset}"

        log    create_gemset if verbose?
        system create_gemset if env.gemset && !pretend?
      end

      def rubies
        env.gemset ? super.map { |ruby| "#{ruby}@#{env.gemset}" } : super
      end

      def gem
        "#{working_dir.join(repo.name)}-#{version}.gem"
      end

      def gemspec_file
        "#{working_dir.join(repo.name)}.gemspec"
      end

      def version
        ::Gem::Specification.load(working_dir.join(gemspec_file)).version.to_s
      end

    end # class Gem
  end # class Command
end # module Testor

