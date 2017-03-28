require "spec_helper"

RSpec.describe Rack::BlacklistCookies do
  let(:subject) { described_class }

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

    it "sets the configuration on the request" do
      expect(subject.configuration.request_blacklist).to eq(request_blacklist)
    end

    it "sets the configuration on the response" do
      expect(subject.configuration.response_blacklist).to eq(response_blacklist)
    end
  end

  context "incorrectly setting up the configuration" do
    before do
      Rack::BlacklistCookies.configure do |config|
        config.request_blacklist = {}
        config.response_blacklist = {}
      end
    end

    after(:each) do
      Rack::BlacklistCookies.configure do |config|
        config.request_blacklist = {}
        config.response_blacklist = {}
      end
    end

    let(:route) { "/some_route" }
    let(:cookies_list) { ["cookie_name"] }
    let(:response_blacklist) do
      {
        route => cookies_list
      }
    end

    context "when the blacklist is not a hash" do
      let(:response_blacklist) { :not_a_hash }
      it "raises an error" do
        expect do
          Rack::BlacklistCookies.configure do |config|
            config.response_blacklist = response_blacklist
          end
        end.to raise_error(Rack::BlacklistCookies::ConfigurationError)
      end
    end

    context "when the blacklist is a hash" do
      context "and the route is not correctly configured" do
        let(:route) { :not_a_route }
        it "raises an error" do
          expect do
            Rack::BlacklistCookies.configure do |config|
              config.response_blacklist = response_blacklist
            end
          end.to raise_error(Rack::BlacklistCookies::ConfigurationError)
        end
      end

      context "and the route is correctly configured" do
        context "and it is not a route string" do
          let(:route) { "just_a_string" }
          it "raises an error" do
            expect do
              Rack::BlacklistCookies.configure do |config|
                config.response_blacklist = response_blacklist
              end
            end.to raise_error(Rack::BlacklistCookies::ConfigurationError)
          end
        end
        context "and the list of cookies is not an array" do
          let(:cookies_list) { :not_an_array }
          it "raises an error" do
            expect do
              Rack::BlacklistCookies.configure do |config|
                config.response_blacklist = response_blacklist
              end
            end.to raise_error(Rack::BlacklistCookies::ConfigurationError)
          end
        end
        context "and the list of cookies is an array" do
          context "and the cookie name is not a string" do
            let(:cookies_list) { [:not_a_cookie_name] }
            it "raises an error" do
              expect do
                Rack::BlacklistCookies.configure do |config|
                  config.response_blacklist = response_blacklist
                end
              end.to raise_error(Rack::BlacklistCookies::ConfigurationError)
            end
          end
        end
      end
    end
  end
end
