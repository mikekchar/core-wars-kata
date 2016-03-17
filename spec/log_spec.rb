require_relative "../lib/event"
require_relative "../lib/log"
require_relative "fakes/object"

RSpec.describe Log do
  let(:object0) { FakeObject.new(0) }
  let(:object1) { FakeObject.new(1) }

  subject { Log.new() }

  it "contains no log entries at the beginning" do
    expect(subject.to_strings).to eq([])
  end

  it "can add an event" do
    event = Event.new(0, object0, "added")
    subject.add(event)
    expect(subject.to_strings).to eq(["[0] FakeObject 0 added"])
  end

  it "can be reset" do
    event = Event.new(0, object0, "added")
    subject.add(event)
    subject.reset()
    expect(subject.to_strings).to eq([])
  end

  context "outputting for a certain step_num" do
    before do
      event0 = Event.new(0, object0, "added")
      event1 = Event.new(1, object1, "added")
      subject.add(event0)
      subject.add(event1)
    end

    it "can output for a certain step_num" do
      expect(subject.at_step(0)).to eq(["[0] FakeObject 0 added"])
      expect(subject.at_step(1)).to eq(["[1] FakeObject 1 added"])
    end
  end
end
