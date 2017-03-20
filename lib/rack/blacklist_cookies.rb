# frozen_string_literal: true
module Rack
  # Rack::BlacklistCookies is a middleware that removes selected cookies from the request and / or response.
  class BlacklistCookies
    def initialize(app)
      @app = app
    end

    def call(env)
      env["HTTP_COOKIE"] = Scrubber.scrub(env["HTTP_COOKIE"], request_blacklist(env), RequestParser.new)

      status, headers, body = @app.call(env)

      headers["Set-Cookie"] = Scrubber.scrub(headers["Set-Cookie"], response_blacklist(env), ResponseParser.new)

      [status, headers, body]
    end

    private

    def request_blacklist(env)
      BlacklistCookies.configuration.request_blacklist[env["PATH_INFO"]]
    end

    def response_blacklist(env)
      BlacklistCookies.configuration.response_blacklist[env["PATH_INFO"]]
    end
  end
end
