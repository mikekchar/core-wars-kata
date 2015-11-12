require_relative "../lib/core"

RSpec.describe Core do
  let(:size) { 1000 }
  subject { Core.new(size) }
  it "exists" do
    expect(subject).not_to be_nil
  end

  it "has a size" do
    expect(subject.size).to eq(size)
  end
end
