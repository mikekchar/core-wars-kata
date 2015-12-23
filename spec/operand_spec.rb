require_relative "../lib/operand"

RSpec.describe Operand do
  subject { Operand.new("#", 123) }

  it "exposes the mode" do
    expect(subject.mode).to eq("#")
  end

  it "exposes the number" do
    expect(subject.number).to eq(123)
  end

  it "can be constructed from a string" do
    expect(Operand.build("#123")).to eq(subject)
  end
end
