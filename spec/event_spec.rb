require_relative "../lib/event"

RSpec.describe Event do
  subject { Event.new(12, "Warrior", 0, "added") }

  it "prints a string version of itself" do
    expect(subject.to_s).to eq("[12] Warrior 0 added")
  end
end
