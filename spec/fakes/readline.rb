module Fake
  class Readline
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
end
