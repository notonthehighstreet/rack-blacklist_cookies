require "spec_helper"

RSpec.describe Rack::BlacklistCookies do
  include_context "rack_setup"

  context "stripping cookies off the request" do
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

    it "tries to scrub the request" do
      expect_any_instance_of(Rack::BlacklistCookies::RequestScrubber).to receive(:to_s).and_call_original
      status, headers, body = subject.call(env)
    end
  end

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
        expect_any_instance_of(Rack::BlacklistCookies::ResponseScrubber).to receive(:to_s).and_call_original
        status, headers, body = subject.call(env)
        expect(headers["Set-Cookie"]).to eq(cleaned_response_cookie)
      end
    end

    context "and the path has not been defined" do
      let(:request_path) { "/bananas" }

      it "does not remove any cookies" do
        expect_any_instance_of(Rack::BlacklistCookies::ResponseScrubber).to_not receive(:to_s)
        status, headers, body = subject.call(env)
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

      it "does not try to change the headers" do
        expect_any_instance_of(Rack::BlacklistCookies::RequestScrubber).to_not receive(:to_s)
        subject.call(env)
      end
    end

    context "on the response" do
      let(:response_cookies) { nil }
      it "does not blow up" do
        expect{subject.call(env)}.to_not raise_error
      end

      it "does not try to change the headers" do
        expect_any_instance_of(Rack::BlacklistCookies::ResponseScrubber).to_not receive(:to_s)
        subject.call(env)
      end
    end
  end

  context "when the headers are an empty string" do
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
      let(:request_cookies) { "" }

      it "does not blow up" do
        expect{subject.call(env)}.to_not raise_error
      end

      it "does not try to change the headers" do
        expect_any_instance_of(Rack::BlacklistCookies::RequestScrubber).to_not receive(:to_s)
        subject.call(env)
      end
    end

    context "on the response" do
      let(:response_cookies) { "" }

      it "does not blow up" do
        expect{subject.call(env)}.to_not raise_error
      end

      it "does not try to change the headers" do
        expect_any_instance_of(Rack::BlacklistCookies::ResponseScrubber).to_not receive(:to_s)
        subject.call(env)
      end
    end
  end
end
