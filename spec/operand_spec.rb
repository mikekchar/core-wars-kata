require_relative "../lib/operand"

RSpec.describe Operand do
  subject { Operand.new("#", 123) }

  it "exposes the mode" do
    expect(subject.mode).to eq("#")
  end

  it "exposes the number" do
    expect(subject.number).to eq(123)
  end
end
