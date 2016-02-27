module ZConfig
  class Setup
    attr_accessor :base_path, :environment

    def active_path
      @active_path ||= File.join(base_path, environment.to_s)
    end

    def environment
      @environment ||= :development
    end
  end
end
