module Patentscope

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end

    def configure_from_env
      if self.configuration
        return false
      else
        self.configuration = Configuration.new
        self.configuration.username = ENV['PATENTSCOPE_WEBSERVICE_USERNAME']
        self.configuration.password = ENV['PATENTSCOPE_WEBSERVICE_PASSWORD']
        return true
      end
    end

    def configured?
      (configuration && configuration.username && configuration.password)? true : false
    end

    def reset_configuration
      self.configuration = nil
    end
  end

  class Configuration
    attr_accessor :username, :password

    def initialize
      @username = ''
      @password = ''
    end
  end
end
