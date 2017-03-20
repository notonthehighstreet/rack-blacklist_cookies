# frozen_string_literal: true
module Rack
  class BlacklistCookies
    # The Scrubber class is responsible for removing any unwanted cookies from a given cookies header.
    # It needs to be run with a Parser in order to be able to differentiate between browser
    # generated Request cookie strings, and Rack generated Response cookie strings.
    class Scrubber
      def self.scrub(cookies_header, blacklist, parser = Parser.new)
        return cookies_header unless blacklist && cookies_header

        new_cookies_header = cookies_header.split(parser.splitter)
        blacklist.each do |cookie_name|
          new_cookies_header.reject! { |cookie| "#{cookie_name}=" == cookie[0..cookie_name.length] }
        end

        new_cookies_header.join(parser.joiner)
      end
    end
  end
end
