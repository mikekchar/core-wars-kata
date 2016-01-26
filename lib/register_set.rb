class Cache
  def initialize(mars)
    @mars = mars
    @impl = {}
  end

  def fetch(address)
    @impl[@mars.address(address)] = @mars.fetch(address).clone()
  end

  def write
    @impl.each_pair do |address, instruction|
      @mars.store(address, instruction)
    end
  end

  def inspect(address)
    @impl[@mars.address(address)]
  end
end

class RegisterSet
  attr_reader :pc, :cache

  def initialize(mars, address)
    @mars = mars
    @pc = address
    @cache = Cache.new(@mars)
    @instruction = fetch(@pc)
  end

  # fetch the address and cache the contents
  def fetch(address)
    @cache.fetch(address)
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

  def writeCache
    @cache.write()
  end

  def to_s
    "PC:#{@pc}"
  end

end

