require "spec_helper"

RSpec.describe "scrubbing cookie headers" do
  let(:subject) { Rack::BlacklistCookies::Scrubber }

  context "on the request" do
    let(:parser) { Rack::BlacklistCookies::RequestParser.new }
    let(:request_cookies) do
      "unwanted_cookie=DELETEME; "\
      "preferences=true; "\
      "country=USA; "\
      "session=latest"
    end
    let(:cleaned_request_cookie) do
      "preferences=true; "\
      "country=USA; "\
      "session=latest"
    end
    let(:request_blacklist) { ["unwanted_cookie"] }

    it "scrubs off any unwanted cookies" do
      expect(subject.scrub(request_cookies, request_blacklist, parser)).to eq(cleaned_request_cookie)
    end

    context "with no blacklist" do
      let(:request_blacklist) { nil }
      it "does not scrub any cookies" do
        expect(subject.scrub(request_cookies, request_blacklist, parser)).to eq(request_cookies)
      end
    end
  end

  context "on the response" do
    let(:parser) { Rack::BlacklistCookies::ResponseParser.new }
    let(:response_cookies) do
      "unwanted_cookie=DELETEME; domain=.example.com; path=/\n"\
      "preferences=true; path=/\n"\
      "country=USA; path=/; expires=Sat, 17 Mar 2020 21:00:00 -0000\n"\
      "session=latest; domain=.open.example.com; path=/; HttpOnly"
    end

    let(:cleaned_response_cookie) do
      "preferences=true; path=/\n"\
      "country=USA; path=/; expires=Sat, 17 Mar 2020 21:00:00 -0000\n"\
      "session=latest; domain=.open.example.com; path=/; HttpOnly"
    end
    let(:response_blacklist) { ["unwanted_cookie"] }

    it "scrubs off any unwanted cookies" do
      expect(subject.scrub(response_cookies, response_blacklist, parser)).to eq(cleaned_response_cookie)
    end

    context "with no blacklist" do
      let(:response_blacklist) { nil }
      it "does not scrub any cookies" do
        expect(subject.scrub(response_cookies, response_blacklist, parser)).to eq(response_cookies)
      end
    end
  end
end
