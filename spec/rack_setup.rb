# frozen_string_literal: true
RSpec.shared_context "rack_setup", :shared_context => :metadata do
  # This shared context sets up stubs and mocks that a Rack app
  # would expect to see in the request / response cycle.
  before { allow(app).to receive(:call).with(env).and_return([status, headers, body]) }

  let(:app) { double("Rack::Sendfile")}
  let(:env) do
    {
      "HTTP_COOKIE" => request_cookies,
      "PATH_INFO" => request_path
    }
  end

  let(:status) { 200 }
  let(:headers) do
    {
      "Set-Cookie" => response_cookies
    }
  end
  let(:body) { double("Rack::BodyProxy") }

  # Fallback to empty string in case these aren't used in a spec
  let(:request_cookies) { "" }
  let(:response_cookies) { "" }
  let(:request_path) { "" }
end
