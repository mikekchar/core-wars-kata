# This is a fake class that implements
# the readline method for the Readline module.
class FakeReadline
  def initialize
    @input = []
  end

  def readline(prompt, storeHistory)
    @input.shift
  end

  def addInput(input)
    @input << input
  end
end

