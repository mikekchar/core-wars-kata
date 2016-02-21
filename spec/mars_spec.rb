require_relative "../lib/mars"
require_relative "../lib/core"
require_relative "fakes/io"

RSpec.describe Mars do
  let(:core) { Core.new(1024) }
  let(:logWriter) { Fake::IO.new() }
  subject    { Mars.new(core, logWriter) }

  describe "delegation to core" do
    it "delegates address" do
      expect(core).to receive(:address)
      subject.address(123)
    end

    it "delegates store" do
      expect(core).to receive(:store)
      subject.store(123, "fake instruction")
    end

    it "delegates fetch" do
      expect(core).to receive(:fetch)
      subject.fetch(123)
    end
  end
end
