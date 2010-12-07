require 'yaml'
require 'ruby-github'

module Testor

  class Metadata

    class Source

      def self.new(filename, *args)
        return super if self < Source
        if filename.file?
          Yaml.new(filename)
        else
          Github.new(filename, *args)
        end
      end

      attr_reader :filename

      def initialize(filename)
        @filename = filename
      end

      def load
        raise NotImplementedError
      end

      def save(repositories)
        File.open(filename, 'w') do |f|
          f.write(YAML.dump({
            'repositories' => repositories.map { |repo| { 'name' => repo['name'], 'url' => repo['url'] } }
          }))
        end
        repositories
      end

      class Github < Source

        attr_reader :username

        def initialize(filename, username)
          super(filename)
          @username = username
        end

        def load
          save(GitHub::API.user(username).repositories)
        end

      end # class Github

      class Yaml < Source

        def load
          YAML.load(File.open(filename))['repositories'].map do |repo|
            Struct.new(:name, :url).new(repo['name'], repo['url'])
          end
        end

      end # class Yaml

    end # class Source

    attr_reader :root
    attr_reader :name
    attr_reader :repositories
    attr_reader :filename

    def self.load(root, name)
      new(root, name).repositories
    end

    def initialize(root, name)
      @root, @name  = root, name
      @filename     = @root.join(config_file_name)
      @source       = Source.new(@filename, name)
      @repositories = @source.load
    end

    def save
      @source.save(repositories)
      self
    end

    def config_file_name
      'dm-dev.yml'
    end

    def include?(url)
      repositories.map { |repo| repo.url}.include?(url)
    end

  end # class Metadata
end # module Testor

