# frozen_string_literal: true
module Rack
  class BlacklistCookies
    # The Scrubber class is responsible for removing any unwanted cookies from a given cookies header.
    # The base class provides the main #scrub method, while the subclasses are responsible
    # for being able to deal with parsing the Request and Response headers and associated config.
    class BaseScrubber
      attr_reader :env

      def initialize(env, cookies_header)
        @env = env
        @cookies_header = cookies_header
      end

      def scrub
        return @cookies_header unless blacklist

        new_cookies_header = @cookies_header.split(splitter)
        blacklist.each do |cookie_name|
          new_cookies_header.reject! { |cookie| "#{cookie_name}=" == cookie[0..cookie_name.length] }
        end

        new_cookies_header.join(joiner)
      end

      def blacklist; end

      def splitter; end

      def joiner; end
    end

    # RequestScrubber is responsible for parsing and configuring the request according to RFC-6252
    # https://tools.ietf.org/html/rfc6265#section-5.4
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cookie
    class RequestScrubber < BaseScrubber
      def blacklist
        BlacklistCookies.configuration.request_blacklist[env["PATH_INFO"]]
      end

      def splitter
        /[;,] */n
      end

      def joiner
        "; "
      end
    end

    # ResponseScrubber is responsible for parsing and configuring the response according to RFC-6252
    # https://tools.ietf.org/html/rfc6265#section-4.1
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie
    class ResponseScrubber < BaseScrubber
      def blacklist
        BlacklistCookies.configuration.response_blacklist[env["PATH_INFO"]]
      end

      def splitter
        "\n"
      end

      def joiner
        "\n"
      end
    end
  end
end
