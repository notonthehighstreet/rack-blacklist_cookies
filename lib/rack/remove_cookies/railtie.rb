module Rack
  class RemoveCookies::Railtie < Rails::Railtie
    initializer "rack.remove_cookies.initializer" do |app|
      # TODO make configurable via app.middleware.insert_after
      app.middleware.insert 0, Rack::RemoveCookies
    end
  end
end
