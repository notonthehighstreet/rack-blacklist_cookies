# frozen_string_literal: true
module Rack
  class BlacklistCookies
    # The Parser class acts as a base class for any kind of cookie string parser.
    class Parser
      def splitter; end

      def joiner; end
    end

    # RequestParser splits and joins cookie headers on the request according to RFC-6252
    # https://tools.ietf.org/html/rfc6265#section-5.4
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cookie
    class RequestParser < Parser
      def splitter
        /[;,] */n
      end

      def joiner
        "; "
      end
    end

    # ResponseParser splits and joins cookie headers on the response according to RFC-6252
    # https://tools.ietf.org/html/rfc6265#section-4.1
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie
    class ResponseParser < Parser
      def splitter
        "\n"
      end

      def joiner
        "\n"
      end
    end
  end
end
