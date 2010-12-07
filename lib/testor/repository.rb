require 'addressable/uri'

module Testor

  class Repository

    attr_reader :path
    attr_reader :name
    attr_reader :uri

    def initialize(root, repo)
      @name = repo.name
      @path = root.join(@name)
      @uri  = Addressable::URI.parse(repo.url)
    end

    def installable?
      path.join('Gemfile').file?
    end

  end # class Repository
end # module Testor

