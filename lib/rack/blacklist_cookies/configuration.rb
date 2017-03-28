# frozen_string_literal: true
module Rack
  class BlacklistCookies
    # Configuration defaults to an empty hash if it has not been set.
    class Configuration
      attr_accessor :request_blacklist, :response_blacklist

      def initialize
        @request_blacklist = {}
        @response_blacklist = {}
      end

      def reset
        @request_blacklist = {}
        @response_blacklist = {}
      end

      # rubocop:disable MethodLength
      def validate
        [@request_blacklist, @response_blacklist].each do |blacklist|
          raise ConfigurationError, "Blacklist is not a hash" unless blacklist.is_a?(Hash)
          blacklist.each do |route, cookie_list|
            raise ConfigurationError, "Blacklist key is not a string" unless route.is_a?(String)
            raise ConfigurationError, "Blacklist value is not an array" unless cookie_list.is_a?(Array)
            raise ConfigurationError, "Blacklist key is not a URL path" unless route.start_with?("/")
            cookie_list.each do |cookie_name|
              raise ConfigurationError, "Blacklist cookie is not a valid name string" unless cookie_name.is_a?(String)
            end
          end
        end
      end
    end

    # ConfigurationError feeds configuration issues back to the user.
    class ConfigurationError < StandardError
      def initialize(message = "Failed to configure correctly")
        @message = message
      end

      def to_s
        "#{@message}. #{docs}"
      end

      def docs
        "Docs are at https://github.com/notonthehighstreet/rack-blacklist_cookies "
      end
    end
  end
end
