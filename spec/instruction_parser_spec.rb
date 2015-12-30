require_relative "../lib/instruction_parser"
require_relative "../lib/dat"
require_relative "../lib/add"

RSpec.describe InstructionParser do
  let(:dat) { Dat.build("#0, #0") }
  let(:add) { Add.build("#123, $-1") }

  it "can parse DAT instructions" do
    expect(InstructionParser.parse("DAT.F #0, #0")).to eq(dat)
  end

  it "can parse ADD instructions" do
    expect(InstructionParser.parse("ADD.AB #123, $-1")).to eq(add)
  end
end
