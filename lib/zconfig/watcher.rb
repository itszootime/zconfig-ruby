module ZConfig
  class Watcher
    def start
      input, output = IO.pipe
      # TODO: what if process gets killed by os?
      @pid = spawn("inotifywait -mrq #{ZConfig.setup.base_path}", out: output)
      output.close
      Thread.new do
        process_and_wait(input)
      end
    end

    def stop
      Process.kill(:SIGINT, @pid) if @pid
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
  end
end
