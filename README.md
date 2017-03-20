# Rack::BlacklistCookies

This gem will block incoming or outgoing cookies on the header on a route-specific basis.

It does this by examining `Cookies` headers on the request, and `Set-Cookie` headers on the response, and stripping out any cookie that has been explicitly blacklisted in the configuration.

This may be useful in situations where you want to continue setting cookies generally but want to apply a finer set of rules to either the request or the response.

## Configuration

All this gem needs to run is a simple configuration file. If you are using this with Rails, then put it in `config/initializers`.

You can blacklist on either the request or the response by setting pairs of `"/url-string" => ["list", "of", "cookies"]` values.

Take the following config as an example:

```ruby
Rack::BlacklistCookies.configure do |config|
  config.request_blacklist = {
    "/some-url"       => ["cookie_to_blacklist", "another_blacklisted_cookie"]
  }
  config.response_blacklist = {
    "/"               => ["do_not_set_this_cookie_on_homepage_response"]
    "/another/url"    => ["cookie_to_blacklist", "another_blacklisted_cookie"]
  }
end
```

Don't forget to add the middleware to `config/application.rb` if you're using Rails.

```ruby
config.middleware.insert 0, Rack::BlacklistCookies
```

As this is a Rack middleware, it will respect and correctly ignore any `?querystring` and `#bookmark` params in the URL.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-blacklist_cookies'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-blacklist_cookies

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/notonthehighstreet/rack-blacklist_cookies. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
