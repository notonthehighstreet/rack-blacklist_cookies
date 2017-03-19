require "spec_helper"

RSpec.describe Rack::BlacklistCookies do
  context "setting up configuration" do

    before do
      Rack::BlacklistCookies.configure do |config|
        config.request_blacklist = request_blacklist
        config.response_blacklist = response_blacklist
      end
    end

    after do
      Rack::BlacklistCookies.configure do |config|
        config.request_blacklist = {}
        config.response_blacklist = {}
      end
    end

    let(:request_blacklist) do
      {
        "/" => ["blacklisted_cookie"]
      }
    end

    let(:response_blacklist) do
      {
        "/" => ["blacklist_cookie", "another_blacklisted_cookie"],
        "/about" => ["blacklist_cookie"]
      }
    end

    let(:subject) { described_class }

    it "sets the configuration on the request" do
      expect(subject.configuration.request_blacklist).to eq(request_blacklist)
    end

    it "sets the configuration on the response" do
      expect(subject.configuration.response_blacklist).to eq(response_blacklist)
    end
  end
end
