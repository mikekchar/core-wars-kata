module Fake
  class IO
    attr_reader :output

    def initialize
      @output = []
    end

    def puts(string)
      @output.push(string)
    end

    def reset
      @output = []
    end
  end
end
