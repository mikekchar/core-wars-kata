require_relative '../lib/options.rb'

RSpec.describe Options do
  let(:args) { "" }
  subject { Options.new() }

  describe "no arguments" do
    it "does nothing" do
      expect(subject.parse(args)).to be_empty
    end
  end

  describe "interactive mode" do
    let(:args) { "-i" }
    it "sets interactive mode" do
      expect(subject.parse(args)).to be_interactive
    end
  end
end
