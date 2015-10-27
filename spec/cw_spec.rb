require_relative "../lib/cw"

RSpec.describe "A starting failed test" do
  it "fails" do
    expect(true).to eq false
  end
end
