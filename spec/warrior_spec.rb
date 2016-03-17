require_relative "../lib/warrior"
require_relative "../lib/core"
require_relative "../lib/add"
require_relative "../lib/dat"
require_relative "setup"

RSpec.describe Warrior do
  include_context "mars setup"

  let(:location) { 10 }
  let(:add) { Add.build("#4, $-1") }
  subject { Warrior.new(mars, 0) }

  before(:each) do
    core.store(location, add)
    subject.new_task(location)
  end

  describe "#step" do
    it "steps for each of the tasks and then writes the cache" do
      expect(subject.tasks).to receive(:step)
      expect(subject.tasks).to receive(:writeCache)
      subject.step()
    end
  end

  describe "#to_s" do
    it "outputs the task information" do
      expect(subject.to_s).to eq("0 - PC:10")
    end
  end

  describe "executing DAT.F" do
    let(:dat) { Dat.build("#0, #0") }

    it "does something" do
      subject.step()
      expect(subject.to_s).to eq("0 - PC:11")
      expect(subject.tasks.length).to eq(1)
      task = subject.tasks[0]
      expect(core.fetch(task.pc())).to eq(dat)
      subject.step()
      expect(subject.to_s).to eq("")
      expect(subject.tasks.length).to eq(0)
    end
  end
end
