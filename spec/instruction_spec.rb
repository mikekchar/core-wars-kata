require_relative "../lib/instruction"

RSpec.describe Instruction do
  let(:fakeA) { "fakeA" }
  let(:fakeB) { "fakeB" }
  let(:dat) { Instruction.new("DAT", "F", fakeA, fakeB) }

  it "exposes its guts" do
    expect(dat.opcode).to eq("DAT")
  end
end
