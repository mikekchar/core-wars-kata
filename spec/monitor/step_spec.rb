require_relative "../../lib/monitor"
require_relative "../../lib/mars"
require_relative "../fakes/readline"
require_relative "../fakes/io"
require_relative "../../lib/monitor/step"
require_relative "../../lib/dat"
require_relative "../../lib/add"
require_relative "../../lib/operand"

RSpec.describe Step do
  let(:core_size) { 1024 }
  let(:mars) { Mars.new(core_size) }
  let(:reader) { Fake::Readline.new() }
  let(:writer) { Fake::IO.new() }
  let(:monitor) { Monitor.new(mars, reader, writer) }

  describe "failing command" do
    subject { Step.new("gobbledegook", monitor) }

    it "is not valid" do
      expect(subject).not_to be_valid
    end
  end

  describe "handling case" do
    subject { Step.new("10s", monitor) }

    it "is valid" do
      expect(subject).to be_valid
    end
  end

  describe "stepping into an executable instruction" do
    let(:location) { 10 }
    let(:add) { Add.build("#123, $-1") }
    subject { Step.new("10S", monitor) }

    it "identifies store commands" do
      expect(subject).to be_valid
    end

    it "adds a warrior..." do
      subject.execute()
      # Not what I really want.  Just a failing test for next time
      expect(monitor.numWarriors).to eq(1)
    end
  end
end
