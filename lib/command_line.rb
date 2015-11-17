require "readline"

class CommandLine
  def initialize(prompt)
    @prompt = prompt
  end

  def read
    Readline.readline(@prompt, true)
  end
end
