require "yaml"

module ZConfig
  class Data
    def initialize(data_path)
      @data_path = data_path
      @values = {}
    end

    def get(*args)
      # TODO: this lookup logic is hard to read
      config_name, lookup_path = args.map(&:to_s)
      load(config_name) unless @values[config_name]

      unless lookup_path
        @values[config_name]
      else
        @values[config_name].fetch(lookup_path, nil) if @values[config_name]
      end
    end

    def load_file(filename)
      path = File.join(@data_path, filename)
      if File.exists?(path)
        @values[filename[0..-5]] = YAML.load(File.read(path))
      end
    end

    private

    def load(config_name)
      load_file("#{config_name}.yml")
    end
  end
end
