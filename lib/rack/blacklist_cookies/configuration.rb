# frozen_string_literal: true
module Rack
  class BlacklistCookies
    class Configuration
      attr_accessor :request_blacklist, :response_blacklist

      def initialize
        @request_blacklist = {}
        @response_blacklist = {}
      end
    end
  end
end
