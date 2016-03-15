require "zconfig/setup"

describe ZConfig::Setup do
  let(:setup) { ZConfig::Setup.new }

  describe "#active_path" do
    it "returns path for current environment" do
      setup.base_path = "/etc/zconfig"
      setup.environment = :test
      expect(setup.active_path).to eq("/etc/zconfig/test")
    end
  end

  describe "#environment" do
    it "returns environment when set" do
      setup.environment = :production
      expect(setup.environment).to eq(:production)
    end

    it "defaults to development" do
      expect(setup.environment).to eq(:development)
    end
  end
end
