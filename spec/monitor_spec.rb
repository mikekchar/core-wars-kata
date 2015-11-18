require_relative "../lib/monitor"
require_relative "fakes/readline"

RSpec.describe Monitor do
  let(:reader) { FakeReadline.new() }
  subject { Monitor.new("> ", reader) }

  describe "reading a single command" do
    let(:command) { "hello" }

    before(:each) do
      reader.addInput(command)
    end

    it "returns the entered command" do
      expect(subject.read()).to eq("hello")
    end
  end

  describe "empty input" do
    # I think readline also returns nil just like
    # the fake.  However, this is obviously a
    # self referential test, so you must be careful
    # I'm only adding it so that when we loop over the
    # input, I'm sure that the tests won't break internally.
    it "returns the error value from readline" do
      expect(subject.read()).to be_nil
    end
  end

  describe "event loop" do
    let(:command1) {"hello"}
    let(:command2) {"world"}

    before(:each) do
      reader.addInput(command1)
      reader.addInput(command2)
    end

    it "reads all of the commands in the input" do
      # Not exactly what I want, but will give us a failing
      # test for tomorrow.  Until then!
      expect(subject.process()).to eq(["hello", "world"])
    end
  end
end
