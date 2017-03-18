require "spec_helper"

RSpec.describe Rack::BlacklistCookies do
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

  context "stripping the cookies off the request" do
    let(:subject) { described_class.new(app) }
    let(:request_cookies) do
      "unwanted_cookie=DELETEME; domain=.example.com; path=/\n"\
      "preferences=true; path=/\n"\
      "country=USA; path=/; expires=Sat, 17 Mar 2020 21:00:00 -0000\n"\
      "session=latest; domain=.open.example.com; path=/; HttpOnly"
    end
    let(:cleaned_request_cookie) do
      "preferences=true; path=/\n"\
      "country=USA; path=/; expires=Sat, 17 Mar 2020 21:00:00 -0000\n"\
      "session=latest; domain=.open.example.com; path=/; HttpOnly"
    end

    context "and the path has been defined" do
      let(:request_path) { "/" }

      it "removes the unwanted cookie and leaves the others" do
        expect(subject).to receive(:remove_request_cookies).with(request_cookies, request_path)
        subject.call(env)
      end
    end

    context "and the path has not been defined" do
      let(:request_path) { "/bananas" }

      it "does not remove any cookies" do
        expect(subject).to_not receive(:remove_request_cookies)
        subject.call(env)
      end
    end
  end

  context "stripping the cookies off the response" do
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
end
