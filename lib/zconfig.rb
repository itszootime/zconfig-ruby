require "zconfig/setup"
require "zconfig/watcher"
require "yaml"

module ZConfig
  # TODO: extract to own class
  @@config = {}

  def self.watch!
    watcher = Watcher.new
    at_exit { watcher.stop }
    watcher.start
  end

  def self.get(*args)
    # TODO: this lookup logic is hard to read
    config_name, lookup_path = args.map(&:to_s)
    load(config_name) unless @@config[config_name]

    unless lookup_path
      @@config[config_name]
    else
      @@config[config_name].fetch(lookup_path, nil) if @@config[config_name]
    end
  end

  def self.load(config_name)
    load_file("#{config_name}.yml")
  end

  def self.load_file(filename)
    path = File.join(@@setup.active_path, filename)
    if File.exists?(path)
      @@config[filename[0..-5]] = YAML.load(File.read(path))
    end
  end

  def self.setup
    return @@setup unless block_given?
    # TODO: user forgets to call setup => uninitialized class variable @@setup
    # TODO: variable/method name confusion, can call with block to setup or without to get
    @@setup = Setup.new
    yield @@setup if block_given?
  end
end
