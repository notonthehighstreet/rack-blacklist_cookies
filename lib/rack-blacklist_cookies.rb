# frozen_string_literal: true
require "rack/blacklist_cookies"
require "rack/blacklist_cookies/configuration"
require "rack/blacklist_cookies/scrubber"

module Rack
  # Rack::BlacklistCookies holds onto configuration values at the class level
  class BlacklistCookies
    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
      configuration.validate
    rescue ConfigurationError => error
      configuration.reset
      raise error
    end

    def self.request_blacklist(env)
      configuration.request_blacklist[env["PATH_INFO"]]
    end

    def self.response_blacklist(env)
      configuration.response_blacklist[env["PATH_INFO"]]
    end
  end
end
