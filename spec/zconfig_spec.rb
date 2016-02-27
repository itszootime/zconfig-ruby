require "zconfig"

describe ZConfig do
  # TODO: let's create some sample configs to load
  let(:base_path) do
    File.expand_path(File.join("..", "fixtures", "base"), __FILE__)
  end

  describe ".setup" do
    it "sets base path"
    it "sets environment"
  end

  describe ".get" do
    before { ZConfig.setup { |s| s.base_path = base_path } }

    it "returns value for given symbol path" do
      expect(ZConfig.get(:servers, :db)).to eq("127.0.0.1")
    end

    it "returns value for given string path" do
      expect(ZConfig.get("servers", "db")).to eq("127.0.0.1")
    end

    it "returns nil when root doesn't exist" do
      expect(ZConfig.get(:foo, :bar)).to be_nil
    end

    it "returns nil when root exists, but key doesn't" do
      expect(ZConfig.get(:servers, :foo)).to be_nil
    end
  end

  describe "file watching" do
    before do
      ZConfig.setup { |s| s.base_path = base_path }
      ZConfig.watch!
    end

    it "reloads config on new file" do
      # TODO: can YAML convert to strings on dump?
      variables = { "foo" => rand(99999) }
      path = File.join(base_path, "development", "variables.yml")
      File.open(path, "w") { |file| file << YAML.dump(variables) }
      expect(ZConfig.get(:variables, :foo)).to eq(variables["foo"])
      File.delete(path)
    end

    it "reloads config on existing file change"
  end
end
