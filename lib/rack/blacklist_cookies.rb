module Rack
  class BlacklistCookies
    def initialize(app)
      @app = app
      @unwanted_cookie_names ||= ["unwanted_cookie"].freeze
    end

    def call(env)
      status, headers, body = @app.call(env)

      headers["Set-Cookie"] = remove_unwanted_cookies(headers["Set-Cookie"]) if homepage?(env)

      [status, headers, body]
    end

    private

    def homepage?(env)
      env["PATH_INFO"] == "/"
    end

    def remove_unwanted_cookies(set_cookie_header)
      new_cookies_header = set_cookie_header.split("\n")
      @unwanted_cookie_names.each do |cookie_name|
        new_cookies_header.reject! { |cookie| "#{cookie_name}=" == cookie[0..cookie_name.length] }
      end
      new_cookies_header.join("\n")
    end
  end
end
