require_relative "../lib/task"
require_relative "../lib/core"
require_relative "../lib/add"
require_relative "../lib/task_queue"
require_relative "setup"

RSpec.describe Task do
  include_context "mars setup"

  let(:location) { 10 }
  let(:add) { Add.build("#4, $-1") }
  let(:queue) { TaskQueue.new(mars, "0") }
  subject { queue.new_task(location) }

  before(:each) do
    core.store(location, add)
  end

  describe "#step" do
    it "increments the PC" do
      subject.step()
      expect(subject.pc).to eq(location + 1)
    end

    describe "at the end of memory" do
      let(:location) { core_size - 1 }

      it "wraps" do
        subject.step()
        expect(subject.pc).to eq(0)
      end
    end
  end

  describe "writeCache" do
    it "writes the register set's cache" do
      expect(subject.registers).to receive(:writeCache)
      subject.writeCache()
    end
  end

  describe "#remove" do
    it "removes itself from its queue" do
      subject.remove()
      expect(queue.length).to eq(0)
    end
  end

  describe "#to_s" do
    it "prints the PC" do
      expect(subject.to_s).to eq("PC:10")
    end
  end
end
