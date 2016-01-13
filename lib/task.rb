class TaskState
  def initialize(mars, address)
    @mars = mars
    @pc = address
    @instruction = @mars.fetch(@pc)
  end

  def incrementPC
    @mars.address(@pc + 1)
  end

  def nextPC
    @instruction.nextPC(self)
  end
end

class Task
  attr_reader :pc

  def initialize(mars, address)
    @mars = mars
    @pc = address
  end

  def step
    state = TaskState.new(@mars, @pc)
    @pc = state.nextPC()
  end

  def to_s
    "PC:#{@pc}"
  end
end
