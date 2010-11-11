require 'testor/command'

module Testor
  class Command

    class Heckle < Command

      attr_reader :spec_dir
      attr_reader :require_path
      attr_reader :root_module
      attr_reader :specs

      def initialize(repo, env, logger)
        super
        @map                   = NameMap.new
        @heckle_caught_modules = Hash.new { |hash, key| hash[key] = [] }
        @unhandled_mutations   = 0
        @spec_dir              = env.options[:spec_dir] || default_spec_dir
        @require_path          = env.options[:require_path]
        @root_module           = env.options[:root_module]
        @specs                 = []
      end

      def run
        super do
          ObjectSpace.each_object(Module) do |mod|

            next if skip_module?(mod)

            # get the public class methods
            metaclass  = class << mod; self end
            ancestors  = metaclass.ancestors

          end
        end
      end

      def default_spec_dir
        Pathname('spec/unit')
      end

      def spec_prefix(mod)
        spec_dir.join(mod.name.underscore)
      end

    private

      def skip_module?(mod)
        not mod.name =~ /\A#{root_module}(?::|\z)/
      end

      def spec_class_methods(mod)
        @spec_class_methods ||= begin
          methods = mod.singleton_methods(false)
          methods.reject! do |method|
            rejected_spec_class_methods.include?(method.to_s)
          end
          if mod.ancestors.include?(Singleton)
            methods.reject! { |method| method.to_s == 'instance' }
          end
          methods
        end
      end

      def other_class_methods(mod)
        @other_class_methods ||= begin
          methods = metaclass.protected_instance_methods(false) | metaclass.private_instance_methods(false)
          ancestors.each do |ancestor|
            methods -= ancestor.protected_instance_methods(false) | ancestor.private_instance_methods(false)
          end
          methods.reject! { |method| method.to_s == 'allocate' }
          methods.reject! do |method|
            next unless method.to_s =~ MEMOIZED_PATTERN && spec_class_methods.any? { |specced| specced.to_s == $1 }
            spec_class_methods(mod) << method
          end
          methods
        end
      end

      def rejected_spec_class_methods
        %w[ yaml_new yaml_tag_subclasses? included nesting constants ]
      end

    end # class Heckle

  end # class Command
end # module Testor

