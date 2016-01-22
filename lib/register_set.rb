class RegisterSet
  attr_reader :pc, :cache

  def initialize(mars, address)
    @mars = mars
    @pc = address
    @cache = {}
    @instruction = fetch(@pc)
  end

  # fetch the address and cache the contents
  def fetch(address)
    cache[@mars.address(address)] = @mars.fetch(address)
  end

  # Used by instructions to calculate the next PC
  # in the case that it is incremented
  def incrementPC
    @mars.address(@pc + 1)
  end

  # Return what the PC should be set to after the instruction
  # has been executed.
  def nextPC
    @instruction.nextPC(self)
  end

  def execute
    @instruction = fetch(@pc)
    @instruction.execute(self)
    @pc = nextPC()
  end
end

