module Rack
  class BlacklistCookies
    def initialize(app)
      @app = app
      @response_blacklist = BlacklistCookies.configuration.response_blacklist
    end

    def call(env)
      status, headers, body = @app.call(env)

      if @response_blacklist[env["PATH_INFO"]]
        @unwanted_cookie_names = @response_blacklist[env["PATH_INFO"]]
        headers["Set-Cookie"] = remove_unwanted_cookies(headers["Set-Cookie"])
      end

      [status, headers, body]
    end

    private

    def remove_unwanted_cookies(set_cookie_header)
      new_cookies_header = set_cookie_header.split("\n")
      @unwanted_cookie_names.each do |cookie_name|
        new_cookies_header.reject! { |cookie| "#{cookie_name}=" == cookie[0..cookie_name.length] }
      end
      new_cookies_header.join("\n")
    end
  end
end
