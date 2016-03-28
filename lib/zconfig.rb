require "zconfig/data"
require "zconfig/setup"
require "zconfig/watcher"

# Global entry-point for setting up, watching and accessing your ZConfig-managed
# configuration.
module ZConfig
  class Error < StandardError; end

  # Returns the global config data instance. If one doesn't exist, it'll be
  # initialised with the current {Setup#active_path}.
  #
  # @return [Data] the global config data instance
  def self.data
    @data ||= Data.new(setup.active_path)
  end

  # Returns the config value at the position specified by the given arguments.
  #
  # @param (see Data#get)
  # @return (see Data#get)
  # @example
  #   ZConfig.get(:servers, :db) # return value for 'db' key from servers.yml
  # @see Data#get
  def self.get(*args)
    data.get(*args)
  end

  # Resets the global {ZConfig} data, setup and watcher.
  def self.reset!
    @watcher.stop if @watcher
    @data, @setup, @watcher = nil
  end

  # If a block is given, the global setup will be yielded to it. Otherwise, the
  # global setup is returned.
  #
  # @yield [Setup] global setup
  # @return [Setup] global setup
  # @example
  #   ZConfig.setup do |s|
  #     s.base_path = "/etc/zconfig"
  #   end
  def self.setup
    if block_given?
      @setup = Setup.new
      yield @setup
    else
      raise Error, "ZConfig hasn't been setup!" unless @setup
      # TODO: this exposes the ability to change setup values after data/watcher
      #   have been initialized, which won't actually do anything
      @setup
    end
  end

  # Starts watching the {Setup#active_path} for changes to config files. If any
  # changes are detected, the config will be reloaded and available for
  # retrieval by {.get}. A call to this method will also add an `at_exit`
  # callback to ensure the watcher is stopped correctly.
  def self.watch!
    @watcher = Watcher.new(setup.active_path)
    @watcher.on_event do |event, _, filename|
      data.load_file(filename) if filename.end_with?(".yml")
    end
    # TODO: multiple calls will add duplicate callbacks
    at_exit { @watcher.stop if @watcher }
    @watcher.start
  end
end
