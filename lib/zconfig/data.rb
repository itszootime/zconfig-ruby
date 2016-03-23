require "yaml"

module ZConfig
  class Data
    def initialize(data_path)
      @data_path = data_path
      @values = {}
    end

    def get(*args)
      root_name, lookup_path = args.map(&:to_s)
      root = get_root(root_name)

      return root unless root && lookup_path
      root.fetch(lookup_path, nil)
    end

    def load_file(filename)
      path = File.join(@data_path, filename)
      if File.exists?(path)
        @values[filename[0..-5]] = YAML.load(File.read(path))
      end
    end

    private

    def get_root(root_name)
      load(root_name) unless @values[root_name]
      @values[root_name]
    end

    def load(root_name)
      load_file("#{root_name}.yml")
    end
  end
end
