require "spec_helper"

RSpec.describe Rack::RemoveCookies do
  include_context "shared"

  let(:subject) { described_class.new(app) }

  context "stripping the cookies off the response" do
    before(:each) { status, headers, body = subject.call(env) }

    let(:response_cookies) do
      "unwanted_cookie=DELETEME; domain=.example.com; path=/\n"\
      "preferences=true; path=/\n"\
      "country=USA; path=/; expires=Sat, 17 Mar 2020 21:00:00 -0000\n"\
      "session=latest; domain=.open.example.com; path=/; HttpOnly"
    end

    let(:stripped_response_cookies) do
      "preferences=true; path=/\n"\
      "country=USA; path=/; expires=Sat, 17 Mar 2020 21:00:00 -0000\n"\
      "session=latest; domain=.open.example.com; path=/; HttpOnly"
    end

    context "and the path has been defined" do
      let(:request_path) { "/" }

      it "removes the unwanted cookie and leaves the others" do
        expect(headers["Set-Cookie"]).to eq(stripped_response_cookies)
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
