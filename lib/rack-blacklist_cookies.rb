require "rack/blacklist_cookies"
require "rack/blacklist_cookies/configuration"

module Rack
  class BlacklistCookies
    class << self
      attr_accessor :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end
