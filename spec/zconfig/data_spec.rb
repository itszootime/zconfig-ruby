require "zconfig"

describe ZConfig::Data do
  let(:path) { File.expand_path("../../fixtures/base/development", __FILE__) }
  let(:data) { ZConfig::Data.new(path) }

  describe "#get" do
    it "returns value for given symbol path" do
      expect(data.get(:servers, :db)).to eq("127.0.0.1")
    end

    it "returns value for given string path" do
      expect(data.get("servers", "db")).to eq("127.0.0.1")
    end

    it "returns nil when root doesn't exist" do
      expect(data.get(:foo, :bar)).to be_nil
    end

    it "returns nil when root exists, but key doesn't" do
      expect(data.get(:servers, :foo)).to be_nil
    end

    it "doesn't call #load_file once cached" do
      expect(data).to receive(:load_file).once.and_call_original
      2.times { data.get(:servers, :db) }
    end
  end

  describe "#load_file" do
    let(:filename) { "numbers.yml" }
    let(:file_path) { File.join(path, filename) }

    before do
      File.open(file_path, "w") { |file| file << YAML.dump("two" => 2) }
    end

    after { File.delete(file_path) }

    it "loads values from yaml file given by name" do
      data.load_file(filename)
      expect(data.get(:numbers, :two)).to eq(2)
    end
  end
end
