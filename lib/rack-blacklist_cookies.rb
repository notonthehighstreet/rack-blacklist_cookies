# frozen_string_literal: true
require "rack/blacklist_cookies"
require "rack/blacklist_cookies/configuration"
require "rack/blacklist_cookies/parsers"
require "rack/blacklist_cookies/scrubber"

module Rack
  # Rack::BlacklistCookies holds onto configuration values at the class level
  class BlacklistCookies
    class << self
      attr_reader :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end
