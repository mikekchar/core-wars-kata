require_relative "../lib/command_line"

RSpec.describe CommandLine do
  let(:command) { "hello" }
  subject { CommandLine.new("> ") }
  before(:each) do
    allow(Readline).to receive(readline) { command }
  end
  it "reads a command" do
    expect(subject.read()).to eq("hello")
  end
end
