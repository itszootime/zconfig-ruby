require "zconfig/data"
require "zconfig/setup"
require "zconfig/watcher"

module ZConfig
  class Error < StandardError; end

  def self.data
    @data ||= Data.new(setup.active_path)
  end

  def self.get(*args)
    # TODO: use delegate
    data.get(*args)
  end

  def self.reset!
    @watcher.stop if @watcher
    @data, @setup, @watcher = nil
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
    @watcher = Watcher.new(setup.active_path)
    @watcher.on_event do |event, _, filename|
      data.load_file(filename) if filename.end_with?(".yml")
    end
    # TODO: multiple calls will add duplicate callbacks
    at_exit { @watcher.stop if @watcher }
    @watcher.start
  end
end
