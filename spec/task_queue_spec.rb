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

    describe "status" do
      it "returns an empty array" do
        expect(subject.status()).to eq([])
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
  end
end
