require "zconfig"

describe ZConfig::Watcher do
  let(:watch_path) do
    File.expand_path("../../fixtures/base/development", __FILE__)
  end

  let(:watcher) { ZConfig::Watcher.new(watch_path) }

  describe "#start" do
    context "when inotifywait can't be found" do
      before { allow(Kernel).to receive(:spawn).and_raise(Errno::ENOENT) }

      it "raises ZConfig::Error" do
        expect { watcher.start }.to raise_error(ZConfig::Error)
      end
    end
  end

  context "after #start" do
    let(:filename) { "test.yml" }

    before do
      write_file(filename, "foo")
      watcher.start
    end

    after do
      watcher.stop
      delete_file(filename)
    end

    it "fires callbacks at least once when file is modified" do
      callback = lambda { |event, path, filename| }
      watcher.on_event(&callback)
      expect(callback).to receive(:call).with(:modify, watch_path, filename)
        .at_least(:once)
      write_file(filename, "bar")
    end
  end

  describe "#stop" do
    it "releases file handles"
  end

  def write_file(filename, content)
    File.open(File.join(watch_path, filename), "w") { |file| file << content }
    sleep(0.1) # TODO: not ideal to introduce a sleep into specs
  end

  def delete_file(filename)
    File.delete(File.join(watch_path, filename))
  end
end
