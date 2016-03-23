module ZConfig
  # Holds runtime setup variables for {ZConfig}.
  class Setup
    attr_accessor :base_path, :environment

    # Returns the active path - the sub-directory of {#base_path} for the
    # current {#environment}.
    #
    # @return [String] the active path
    def active_path
      @active_path ||= File.join(base_path, environment.to_s)
    end

    # Returns the current environment (defaults to `:development`).
    #
    # @return [Symbol] the current environment
    def environment
      @environment ||= :development
    end
  end
end
