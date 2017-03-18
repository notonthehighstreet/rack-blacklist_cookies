module Rack
  class BlacklistCookies::Configuration
    attr_accessor :request_blacklist, :response_blacklist

    def initialize
      @request_blacklist = {}
      @response_blacklist = {}
    end
  end
end
