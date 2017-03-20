require "spec_helper"

RSpec.describe Rack::BlacklistCookies do
  include_context "rack_setup"

  context "stripping the cookies off the response" do
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

    let(:subject) { described_class.new(app) }
    before(:each) { status, headers, body = subject.call(env) }

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

    context "and the path has been defined" do
      let(:request_path) { "/" }

      it "removes the unwanted cookie and leaves the others" do
        expect(headers["Set-Cookie"]).to eq(cleaned_response_cookie)
      end
    end

    context "and the path has not been defined" do
      let(:request_path) { "/bananas" }

      it "does not remove any cookies" do
        expect(headers["Set-Cookie"]).to eq(response_cookies)
      end
    end
  end

  context "when there are no headers" do
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
    let(:subject) { described_class.new(app) }
    let(:request_path) { "/" }
    context "on the request" do
      let(:request_cookies) { nil }
      it "does not blow up" do
        expect{subject.call(env)}.to_not raise_error
      end
    end
    context "on the response" do
      let(:response_cookies) { nil }
      it "does not blow up" do
        expect{subject.call(env)}.to_not raise_error
      end
    end
  end
end
