require_relative "../lib/event"

RSpec.describe Event do
  subject { Event.new("Warrior", 0, "added") }

  it "prints a string version of itself" do
    expect(subject.to_s).to eq(">> Warrior 0 added")
  end
end
