require_relative "../lib/task_queue"
require_relative "../lib/task"
require_relative "../lib/core"
require_relative "../lib/mars"

RSpec.describe TaskQueue do
  let(:core_size) { 1024 }
  let(:core) { Core.new(core_size) }
  let(:mars) { Mars.new(core) }
  let(:location) { 10 }
  subject { TaskQueue.new(mars) }

  describe "#new_task" do
    it "returns the added task" do
      task = subject.new_task(location)
      expect(task.class).to eq(Task)
    end
  end

  describe "when queue is empty" do
    it "starts has an empty queue" do
      expect(subject.length).to eq(0)
    end

    describe "#step" do
      it "does not crash" do
        subject.step()
      end
    end

    describe "#writeCache" do
      it "should not attempt to write to the core" do
        expect(core).not_to receive(:store)
        subject.writeCache()
      end
    end

    describe "#status" do
      it "returns an empty array" do
        expect(subject.status()).to eq([])
      end
    end

    describe "#remove" do
      it "does nothing" do
        expect(subject.remove("fake task")).to be_nil
        expect(subject.length).to eq(0)
      end
    end
  end

  describe "when queue has tasks" do
    before(:each) do
      @task1 = subject.new_task(location)
      @task2 = subject.new_task(location + 1)
      @task3 = subject.new_task(location + 2)
    end

    it "knows the length of the queue" do
      expect(subject.length).to eq(3)
    end

    describe "#step" do
      it "steps each task" do
        expect(@task1).to receive(:step)
        expect(@task2).to receive(:step)
        expect(@task3).to receive(:step)
        subject.step()
      end
    end

    describe "#writeCache" do
      it "writes the cache for each task" do
        expect(@task1).to receive(:writeCache)
        expect(@task2).to receive(:writeCache)
        expect(@task3).to receive(:writeCache)
        subject.writeCache()
      end
    end

    describe "#status" do
      it "has status for each task" do
        expect(subject.status()).to eq(
          [
            "PC:10",
            "PC:11",
            "PC:12"
          ]
        )
      end
    end

    describe "#remove" do
      it "removes the task" do
        subject.remove(@task1)
        expect(subject[0]).to be(@task2)
        expect(subject[1]).to be(@task3)
        expect(subject[2]).to be(nil)
        expect(subject.length).to eq(2)
      end

      it "returns the removed task" do
        expect(subject.remove(@task1)).to be(@task1)
      end

      it "doesn't remove tasks that don't exist" do
        expect(subject.remove("fake task")).to be_nil
        expect(subject.length).to eq(3)
      end
    end
  end
end
