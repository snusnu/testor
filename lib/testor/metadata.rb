require 'yaml'
require 'ruby-github'

module Testor

  class Metadata

    attr_reader :root
    attr_reader :name
    attr_reader :repositories

    def self.fetch(root, name)
      new(root, name).repositories
    end

    def initialize(root, name)
      @root, @name  = root, name
      @repositories = fetch
    end

    def fetch
      filename = root.join(config_file_name)
      if filename.file?
        load_from_yaml(filename)
      else
        load_from_github(filename)
      end
    end

    def config_file_name
      'testor.yml'
    end

    def load_from_github(filename)
      cache(GitHub::API.user(name).repositories, filename)
    end

    def load_from_yaml(filename)
      YAML.load(File.open(filename))['repositories'].map do |repo|
        Struct.new(:name, :url).new(repo['name'], repo['url'])
      end
    end

  private

    def cache(repos, filename)
      File.open(filename, 'w') do |f|
        f.write(YAML.dump({
          'repositories' => repos.map { |repo| { 'name' => repo.name, 'url' => repo.url } }
        }))
      end
      repos
    end

  end # class Metadata
end # module Testor

