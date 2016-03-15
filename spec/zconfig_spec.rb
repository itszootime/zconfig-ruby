require "spec_helper"

describe ZConfig do
  let(:base_path) do
    File.expand_path("../fixtures/base", __FILE__)
  end

  after { clean_config_path }

  describe ".setup" do
    it "yields given block with setup instance" do
      expect { |s| ZConfig.setup(&s) }.to yield_with_args(ZConfig::Setup)
    end

    it "returns yielded setup instance without given block" do
      yielded_setup = nil
      ZConfig.setup { |s| yielded_setup = s }
      expect(ZConfig.setup).to eq(yielded_setup)
    end
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
      variables = { "foo" => rand(999) }
      create_or_modify_config("variables", variables)
      expect(ZConfig.get(:variables, :foo)).to eq(variables["foo"])
    end

    it "reloads config on existing file change" do
      variables = { "foo" => rand(999) }
      create_or_modify_config("variables", variables)
      expect(ZConfig.get(:variables, :foo)).to eq(variables["foo"])
      variables["bar"] = rand(999)
      create_or_modify_config("variables", variables)
      expect(ZConfig.get(:variables, :bar)).to eq(variables["bar"])
    end
  end

  def create_or_modify_config(name, values)
    # TODO: can YAML convert to strings on dump?
    path = File.join(base_path, "development", "#{name}.yml")
    File.open(path, "w") { |file| file << YAML.dump(values) }
    # TODO: not ideal to introduce a sleep into specs
    sleep(0.1)
  end

  def clean_config_path
    Dir[File.join(base_path, "development", "**", "*")].each do |file|
      File.delete(file) unless /servers.yml/.match(file)
    end
  end
end
