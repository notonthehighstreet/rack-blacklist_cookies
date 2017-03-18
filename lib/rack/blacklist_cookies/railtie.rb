module Rack
  class BlacklistCookies::Railtie < Rails::Railtie
    initializer "rack.blacklist_cookies.initializer" do |app|
      # TODO make configurable via app.middleware.insert_after
      app.middleware.insert 0, Rack::BlacklistCookies
    end
  end
end
