# frozen_string_literal: true
module Rack
  class BlacklistCookies
    def initialize(app)
      @app = app
      @request_blacklist = BlacklistCookies.configuration.request_blacklist
      @response_blacklist = BlacklistCookies.configuration.response_blacklist
    end

    def call(env)
      current_path = env["PATH_INFO"]

      if @request_blacklist[current_path]
        env["HTTP_COOKIE"] = remove_cookies(env["HTTP_COOKIE"], current_path, @request_blacklist)
      end

      status, headers, body = @app.call(env)

      if @response_blacklist[current_path]
        headers["Set-Cookie"] = remove_cookies(headers["Set-Cookie"], current_path, @response_blacklist)
      end

      [status, headers, body]
    end

    private

    def remove_cookies(cookie_header, current_path, blacklist)
      new_cookies_header = cookie_header.split("\n")
      blacklist[current_path].each do |cookie_name|
        new_cookies_header.reject! { |cookie| "#{cookie_name}=" == cookie[0..cookie_name.length] }
      end
      new_cookies_header.join("\n")
    end
  end
end
