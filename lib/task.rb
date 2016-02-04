require_relative "./register_set"

class Task
  attr_reader :registers

  def initialize(queue, mars, address)
    @queue = queue
    @mars = mars
    @registers = RegisterSet.new(mars, address)
  end

  def step
    @registers = RegisterSet.new(@mars, pc())
    @registers.execute()
    remove() if !@registers.alive
  end

  def writeCache
    @registers.writeCache()
  end

  def remove
    @queue.remove(self)
  end

  def to_s
    @registers.to_s()
  end

  def pc
    @registers.pc
  end
end
