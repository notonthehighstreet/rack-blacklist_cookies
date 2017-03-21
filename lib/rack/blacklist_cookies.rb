# frozen_string_literal: true
module Rack
  # Rack::BlacklistCookies is a middleware that removes selected cookies from the request and / or response.
  class BlacklistCookies
    def initialize(app)
      @app = app
    end

    def call(env)
      env["HTTP_COOKIE"] = "#{RequestScrubber.new(env, env["HTTP_COOKIE"])}" if env["HTTP_COOKIE"]

      status, headers, body = @app.call(env)

      headers["Set-Cookie"] = "#{ResponseScrubber.new(env, headers["Set-Cookie"])}" if headers["Set-Cookie"]

      [status, headers, body]
    end
  end
end
