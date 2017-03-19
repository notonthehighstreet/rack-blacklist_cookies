# frozen_string_literal: true
module Rack
  # Rack::BlacklistCookies is the main class that acts as the Rack middleware.
  class BlacklistCookies
    def initialize(app)
      @app = app
      @request_blacklist = BlacklistCookies.configuration.request_blacklist
      @response_blacklist = BlacklistCookies.configuration.response_blacklist
    end

    def call(env)
      current_path = env["PATH_INFO"]

      if @request_blacklist[current_path]
        env["HTTP_COOKIE"] = remove_cookies(env["HTTP_COOKIE"], @request_blacklist[current_path])
      end

      status, headers, body = @app.call(env)

      if @response_blacklist[current_path]
        headers["Set-Cookie"] = remove_cookies(headers["Set-Cookie"], @response_blacklist[current_path])
      end

      [status, headers, body]
    end

    private

    def remove_cookies(cookie_header, blacklist)
      new_cookies_header = cookie_header.split("\n")
      blacklist.each do |cookie_name|
        new_cookies_header.reject! { |cookie| "#{cookie_name}=" == cookie[0..cookie_name.length] }
      end
      new_cookies_header.join("\n")
    end
  end
end
