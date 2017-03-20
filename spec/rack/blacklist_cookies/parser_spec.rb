require "spec_helper"

RSpec.describe "parsers" do
  context "the base parser" do
    let(:subject) { Rack::BlacklistCookies::Parser.new }
    it "has a splitter method" do
      expect(subject).to respond_to(:splitter)
    end
    it "has a joiner method" do
      expect(subject).to respond_to(:joiner)
    end
  end

  context "the request parser" do
    let(:subject) { Rack::BlacklistCookies::RequestParser.new }
    it "returns the correct string for splitting a request cookie header" do
      expect(subject.splitter).to eq(/[;,] */n)
    end
    it "returns the correct string for joinng the request cookie header" do
      expect(subject.joiner).to eq("; ")
    end
  end

  context "the response parser" do
    let(:subject) { Rack::BlacklistCookies::ResponseParser.new }
    it "returns the correct string for splitting a response cookie header" do
      expect(subject.splitter).to eq("\n")
    end
    it "returns the correct string for joinng the response cookie header" do
      expect(subject.joiner).to eq("\n")
    end
  end
end
