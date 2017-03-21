require "spec_helper"

RSpec.describe Rack::BlacklistCookies::RequestScrubber do
  include_context "rack_setup"

  before do
    Rack::BlacklistCookies.configure do |config|
      config.request_blacklist = {
        "/" => ["unwanted_cookie"],
      }
      config.response_blacklist = {
        "/" => ["unwanted_cookie"],
      }
    end
  end

  let(:request_path) { "/" }

  context "on the request" do
    let(:subject) { Rack::BlacklistCookies::RequestScrubber }
    let(:request_cookies) do
      "unwanted_cookie=DELETEME; "\
      "preferences=true; "\
      "country=USA; "\
      "session=latest"
    end
    let(:cleaned_request_cookies) do
      "preferences=true; "\
      "country=USA; "\
      "session=latest"
    end

    it "scrubs off any unwanted cookies" do
      expect(subject.new(env, env["HTTP_COOKIE"]).to_s).to eq(cleaned_request_cookies)
    end

    context "with no blacklist" do
      let(:request_path) { "/bananas" }
      it "does not scrub any cookies" do
        expect(subject.new(env, env["HTTP_COOKIE"]).to_s).to eq(request_cookies)
      end
    end
  end

  context "on the response" do
    let(:subject) { Rack::BlacklistCookies::ResponseScrubber }
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

    it "scrubs off any unwanted cookies" do
      expect(subject.new(env, headers["Set-Cookie"]).to_s).to eq(cleaned_response_cookie)
    end

    context "with no blacklist" do
      let(:request_path) { "/bananas" }
      it "does not scrub any cookies" do
        expect(subject.new(env, headers["Set-Cookie"]).to_s).to eq(response_cookies)
      end
    end
  end
end
