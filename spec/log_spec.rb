require_relative "../lib/event"
require_relative "../lib/log"

RSpec.describe Log do
  subject { Log.new() }

  it "contains no log entries at the beginning" do
    expect(subject.to_strings).to eq([])
  end

  it "can add an event" do
    event = Event.new(0, "Warrior", 0, "added")
    subject.add(event)
    expect(subject.to_strings).to eq(["[0] Warrior 0 added"])
  end

  it "can be reset" do
    event = Event.new(0, "Warrior", 0, "added")
    subject.add(event)
    subject.reset()
    expect(subject.to_strings).to eq([])
  end

  context "outputting for a certain step_num" do
    before do
      event0 = Event.new(0, "Warrior", 0, "added")
      event1 = Event.new(1, "Warrior", 1, "added")
      subject.add(event0)
      subject.add(event1)
    end

    it "can output for a certain step_num" do
      expect(subject.at_step(0)).to eq(["[0] Warrior 0 added"])
      expect(subject.at_step(1)).to eq(["[1] Warrior 1 added"])
    end
  end
end
