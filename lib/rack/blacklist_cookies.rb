# frozen_string_literal: true
module Rack
  # Rack::BlacklistCookies is a middleware that removes selected cookies from the request and / or response.
  class BlacklistCookies
    def initialize(app)
      @app = app
    end

    def call(env)
      env["HTTP_COOKIE"] = "#{RequestScrubber.new(env, env["HTTP_COOKIE"])}" if scrub_request?(env)

      status, headers, body = @app.call(env)

      headers["Set-Cookie"] = "#{ResponseScrubber.new(env, headers["Set-Cookie"])}" if scrub_response?(env, headers)

      [status, headers, body]
    end

    private

    def scrub_request?(env)
      !env["HTTP_COOKIE"].nil? && !env["HTTP_COOKIE"].empty? && BlacklistCookies.request_blacklist(env)
    end

    def scrub_response?(env, headers)
      !headers["Set-Cookie"].nil? && !headers["Set-Cookie"].empty? && BlacklistCookies.response_blacklist(env)
    end
  end
end
