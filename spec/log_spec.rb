require_relative "../lib/event"
require_relative "../lib/log"

RSpec.describe Log do
  subject { Log.new() }

  it "contains no log entries at the beginning" do
    expect(subject.to_strings).to eq([])
  end

  it "can add an event" do
    event = Event.new("Warrior", 0, "added")
    subject.add(event)
    expect(subject.to_strings).to eq([">> Warrior 0 added"])
  end
end
