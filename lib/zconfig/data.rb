require "yaml"

module ZConfig
  # Responsible for loading, caching and retrieving config data. Data is loaded
  # from YAML files located in the path specified in {#initialize}. Each file
  # forms a root for value retrieval using {#get}.
  class Data
    # Creates a new {Data} instance.
    #
    # @param path [String] the path where your YAML files reside
    def initialize(path)
      @path = path
      @values = {}
    end

    # Returns the value at the position specified by the given arguments. The
    # first argument should be the root name (i.e. `:servers` for a file called
    # servers.yml). Subsequent arguments locate the key you wish to return the
    # value for.
    #
    # @param args [String, Symbol] the position to retrieve the value for
    # @return [Object] the value at the position specified, or `nil` if a value
    #   could not be found
    # @example
    #   data.get(:servers, :db) # return value for 'db' key from servers.yml
    def get(*args)
      root_name, lookup_path = args.map(&:to_s)
      root = get_root(root_name)

      return root unless root && lookup_path
      root.fetch(lookup_path, nil)
    end

    # Attempts to load values from a YAML file with the given filename located
    # in the `path`. If a file with the given filename has already been loaded,
    # this call will overwrite all existing values.
    #
    # @param filename [String] the name of the file to load
    # @example
    #   data.load_file("numbers.yml") # call data.get(:numbers) to retrieve
    def load_file(filename)
      file_path = File.join(@path, filename)
      if File.exists?(file_path)
        @values[filename[0..-5]] = YAML.load(File.read(file_path))
      end
    end

    private

    # Returns the root values for the given name. For a file named
    # 'servers.yml', the root name will be 'servers'.
    #
    # @param root_name [String] the name of the root to return values for
    def get_root(root_name)
      load(root_name) unless @values[root_name]
      @values[root_name]
    end

    # Attempts to load values from a YAML file for the given root name located
    # in the `path`.
    #
    # @param root_name [String] the name of the root to load values for
    # @see #load_file
    def load(root_name)
      load_file("#{root_name}.yml")
    end
  end
end
