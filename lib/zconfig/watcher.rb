module ZConfig
  class Watcher
    def initialize(watch_path)
      @watch_path = watch_path
      @callbacks = []
    end

    def on_event(&callback)
      @callbacks << callback
    end

    def start
      input, output = IO.pipe
      # TODO: what if process gets killed by os?
      @pid = spawn("inotifywait -mrq #{@watch_path}", out: output)
      output.close
      Thread.new { process_and_wait(input) }
    end

    def stop
      Process.kill(:SIGINT, @pid) if @pid
    end

    private

    def process_and_wait(input)
      while line = input.readline
        path, event, filename = line.split(/\s/)
        event = event.downcase.to_sym
        # TODO: handle more events
        if event == :modify
          @callbacks.each do |callback|
            callback.call(event, path[0..-2], filename)
          end
        end
      end
    end
  end
end
