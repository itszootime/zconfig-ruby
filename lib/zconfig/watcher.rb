module ZConfig
  # Watches for file changes, subsequently firing event callbacks. Currently
  # only compatible with systems where inotifywait is available.
  class Watcher
    # Creates a new {Watcher} for the given path.
    #
    # @param watch_path [String] the path to watch for changes on
    def initialize(watch_path)
      @watch_path = watch_path
      @callbacks = []
    end

    # Adds a callback to be fired when a file change event occurs.
    #
    # @yield [Symbol, String, String] the event, path and filename upon file
    #   change event
    # @example
    #   watcher.on_event do |event, path, filename|
    #     puts "#{event} occured in #{path} on #{filename}!"
    #   end
    def on_event(&callback)
      @callbacks << callback
    end

    # Starts watching for file changes.
    #
    # @raise [Error] if the watcher couldn't be started
    def start
      input, output = IO.pipe
      begin
        @pid = Kernel.spawn("inotifywait -mrq #{@watch_path}", out: output)
      rescue Errno::ENOENT
        raise Error, "Couldn't start watcher, is inotify-tools installed?"
      end
      output.close
      Thread.new { process_and_wait(input) }
    end

    # Stops watching for file changes. It's important that this method is called
    # before program exit otherwise the underlying process will not be
    # terminated correctly.
    def stop
      Process.kill(:SIGINT, @pid) if @pid
    end

    private

    def process_and_wait(input)
      while line = input.readline
        path, event, filename = line.split(/\s/)
        event = event.downcase.to_sym
        if event == :modify
          @callbacks.each do |callback|
            callback.call(event, path[0..-2], filename)
          end
        end
      end
    end
  end
end
