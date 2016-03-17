require_relative "../lib/event"
require_relative "fakes/object"

RSpec.describe Event do
  let(:object) { FakeObject.new(0) }
  subject { Event.new(12, object, "added") }

  it "prints a string version of itself" do
    expect(subject.to_s).to eq("[12] FakeObject 0 added")
  end
end
