module Testor

  module Utils

    def self.full_const_get(name, root = Object)
      obj = root
      namespaces(name).each do |x|
        # This is required because const_get tries to look for constants in the
        # ancestor chain, but we only want constants that are HERE
        obj = obj.const_defined?(x) ? obj.const_get(x) : obj.const_missing(x)
      end
      obj
    end

    def self.namespaced?(const_name)
      namespaces(const_name).size > 1
    end

    def self.namespaces(const_name)
      path = const_name.to_s.split('::')
      path.shift if path.first.empty?
      path
    end

  end # module Utils
end # module Testor

