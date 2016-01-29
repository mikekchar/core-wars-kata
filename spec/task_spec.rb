require_relative "../lib/task"
require_relative "../lib/core"
require_relative "../lib/mars"
require_relative "../lib/add"
require_relative "../lib/task_queue"

RSpec.describe Task do
  let(:core_size) { 1024 }
  let(:core) { Core.new(core_size) }
  let(:mars) { Mars.new(core) }
  let(:location) { 10 }
  let(:add) { Add.build("#4, $-1") }
  let(:queue) { TaskQueue.new(mars) }
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

  describe "#to_s" do
    it "prints the PC" do
      expect(subject.to_s).to eq("PC:10")
    end
  end
end
