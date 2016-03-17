require_relative "./register_set"

class Task
  attr_reader :registers

  def initialize(queue, core, address, id)
    @queue = queue
    @core = core
    @id = id
    @registers = RegisterSet.new(core, address)
  end

  def name
    "Task"
  end

  def id
    @id 
  end

  def step
    @registers = RegisterSet.new(@core, pc())
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
