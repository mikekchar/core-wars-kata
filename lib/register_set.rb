require_relative "./cache"

class RegisterSet
  attr_reader :pc, :cache, :alive

  def initialize(core, address)
    @core = core
    @pc = address
    @cache = Cache.new(@core)
    @instruction = fetch(@pc)
    @alive = true
  end

  def kill
    @alive = false
  end

  # fetch the address and cache the contents
  def fetch(address)
    @cache.fetch(address)
  end

  # Used by instructions to calculate the next PC
  # in the case that it is incremented
  def incrementPC
    @core.address(@pc + 1)
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

  def writeCache
    @cache.write()
  end

  def to_s
    "PC:#{@pc}"
  end
end

