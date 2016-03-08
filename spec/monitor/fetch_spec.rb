require_relative "../../lib/monitor"
require_relative "../fakes/readline"
require_relative "../fakes/io"
require_relative "../../lib/monitor/fetch"
require_relative "../setup"

RSpec.describe Monitor do
  include_context "monitor setup"

  describe "reading an address" do
    it "identifies addresses" do
      fetch = Fetch.new("1234", monitor) 
      expect(fetch).to be_valid
    end

    it "rejects non-addresses" do
      fetch = Fetch.new("hello", monitor) 
      expect(fetch).not_to be_valid
    end

    describe "fetching an address within bounds" do
      it "outputs the value at an address" do
        fetch = Fetch.new("10", monitor) 
        fetch.execute()
        expect(writer.output).to eq(["10:DAT.F #0, #0"])
      end
    end

    describe "fetching an address out of bounds" do
      it "wraps to zero" do
        # It is numbered from 0, so core.size is out of bounds
        fetch = Fetch.new("#{core_size}", monitor) 
        fetch.execute()
        expect(writer.output).to eq(["0:DAT.F #0, #0"])
      end

      it "wraps to size -x for negative numbers" do
        fetch = Fetch.new("-1", monitor) 
        fetch.execute()
        expect(writer.output).to eq(["#{core_size - 1}:DAT.F #0, #0"])
      end
    end
  end
end
