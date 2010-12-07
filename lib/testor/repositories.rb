require 'pathname'

require 'testor/metadata'
require 'testor/repository'

module Testor

  class Repositories

    include Enumerable

    def initialize(root, user, repos, excluded_repos)
      @root, @user    = root, user
      @repos          = repos
      @excluded_repos = excluded_repos
      @metadata       = Metadata.new(@root, @user)
      @repositories   = selected_repositories.map do |repo|
        Repository.new(@root, repo)
      end
    end

    def each
      @repositories.each { |repo| yield(repo) }
    end

    def add(name, url)
      if @metadata.include?(url)
        puts "#{url} is already managed by dm-dev"
      else
        @metadata.repositories << Struct.new(:name, :url).new(name, url)
        @metadata.save
      end
    end

  private

    def selected_repositories
      if use_current_directory?
        @metadata.repositories.select { |repo| managed_repo?(repo) }
      else
        @metadata.repositories.select { |repo| include_repo?(repo) }
      end
    end

    def managed_repo?(repo)
      repo.name == relative_path_name
    end

    def include_repo?(repo)
      if @repos
        !excluded_repo?(repo) && (include_all? || @repos.include?(repo.name))
      else
        !excluded_repo?(repo)
      end
    end

    def excluded_repo?(repo)
      @excluded_repos.include?(repo.name)
    end

    def use_current_directory?
      @repos.nil? && inside_available_repo? && !include_all?
    end

    def inside_available_repo?
      @metadata.repositories.map(&:name).include?(relative_path_name)
    end

    def include_all?
      explicitly_specified = @repos.respond_to?(:each) && @repos.count == 1 && @repos.first == 'all'
      if inside_available_repo?
        explicitly_specified
      else
        @repos.nil? || explicitly_specified
      end
    end

    def relative_path_name
      Pathname(Dir.pwd).relative_path_from(@root).to_s
    end

  end # class Repositories
end # module Testor

