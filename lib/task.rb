require_relative "./register_set"

class Task
  attr_reader :registers

  def initialize(mars, address)
    @mars = mars
    @registers = RegisterSet.new(mars, address)
  end

  def step
    # FIXME: This construction might be a pain for tests eventually
    @registers = RegisterSet.new(@mars, pc())
    @registers.execute()
  end

  def writeCache
    @registers.writeCache()
  end

  def to_s
    @registers.to_s()
  end

  def pc
    @registers.pc
  end
end
