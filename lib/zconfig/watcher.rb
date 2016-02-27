module ZConfig
  class Watcher
    def start
      # TODO: ensure this thread terminates correctly
      thread = Thread.new do
        # watch_with_spawn
        watch_with_popen
      end
    end

    def stop
      # TODO: close watchers to release file handles
    end

    private

    def process_and_wait(input)
      while line = input.readline
        path, action, filename = line.split(/\s/)
        # TODO: handle more actions
        if action == "MODIFY" && filename.end_with?(".yml")
          # TODO: might be nicer not to rely on ZConfig class vars => how about callbacks?
          ZConfig.load_file(filename)
        end
      end
    end

    def watch_with_spawn
      # TODO: this WILL create danging processes - we need to kill them
      # TODO: what if process gets killed by os?
      input, output = IO.pipe
      spawn("inotifywait -mrq #{ZConfig.setup.base_path}", out: output)
      output.close
      process_and_wait(input)
    end

    def watch_with_popen
      # TODO: is this compatible with all systems?
      # TODO: what if process gets killed by os?
      IO.popen("inotifywait -mrq #{ZConfig.setup.base_path}") do |input|
        process_and_wait(input)
      end
    end
  end
end
