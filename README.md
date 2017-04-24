# Rack::BlacklistCookies

Rack middleware for removing cookies on the request and response at a route level.

Rack::BlacklistCookies is a rack middleware that will block certain cookies from an HTTP request, as well as strip
certain cookies from an HTTP response.

It does this by examining the `Cookies` headers on the request, and the `Set-Cookie` headers on the response, and
stripping out any cookie that has been explicitly blacklisted in the configuration. It also let's you do that on a
per route basis, allowing you to selectively strip certain cookies only for certain routes in your application.

This may be useful in situations where you want to continue setting cookies generally but want to apply a finer set of
rules to either the request or the response.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-blacklist_cookies'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-blacklist_cookies

## Configuration

All this gem needs to run is a simple configuration file.

You can blacklist on either the request or the response by setting pairs of `"/url-string" => ["list", "of", "cookies"]`
values.

Take the following config as an example:

```ruby
Rack::BlacklistCookies.configure do |config|
  config.request_blacklist = {
    "/some-url"       => ["cookie_to_blacklist", "another_blacklisted_cookie"]
  }
  config.response_blacklist = {
    "/"               => ["do_not_set_this_cookie_on_homepage_response"]
  }
end
```

This will ensure requests getting into your application on the URL `/some-url` will not have the cookies
`cookie_to_blacklist` and `another_blacklisted_cookie`. Similarly, even if your web application returns a cookie with
the name `do_not_set_this_cookie_on_homepage_response` for requests to `/`, that cookie will not make it into the client
as the middleware will strip it out.


As this is a Rack middleware, it will respect and correctly ignore any `?querystring` and `#bookmark` params in the URL.

## Using with Rails

If you are using this middleware with Rails, a typical place to set up the gem is in the `config/initializers` folder.

Don't forget to add the middleware to `config/application.rb` as well.

```ruby
config.middleware.insert 0, Rack::BlacklistCookies
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/notonthehighstreet/rack-blacklist_cookies.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
