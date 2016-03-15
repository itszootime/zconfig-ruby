require "zconfig/setup"
require "zconfig/watcher"
require "yaml"

module ZConfig
  class Error < StandardError; end

  def self.config
    @config ||= {}
  end

  def self.get(*args)
    # TODO: this lookup logic is hard to read
    config_name, lookup_path = args.map(&:to_s)
    load(config_name) unless config[config_name]

    unless lookup_path
      config[config_name]
    else
      config[config_name].fetch(lookup_path, nil) if config[config_name]
    end
  end

  def self.reset!
    @config, @setup = nil
  end

  def self.setup
    if block_given?
      @setup = Setup.new
      yield @setup
    else
      raise Error, "ZConfig hasn't been setup!" unless @setup
      @setup
    end
  end

  def self.watch!
    watcher = Watcher.new(setup.active_path)
    watcher.on_event do |event, _, filename|
      load_file(filename) if filename.end_with?(".yml")
    end
    at_exit { watcher.stop }
    watcher.start
  end

  private # of course, this doesn't do anything

  def self.load(config_name)
    load_file("#{config_name}.yml")
  end

  def self.load_file(filename)
    path = File.join(setup.active_path, filename)
    if File.exists?(path)
      config[filename[0..-5]] = YAML.load(File.read(path))
    end
  end
end
