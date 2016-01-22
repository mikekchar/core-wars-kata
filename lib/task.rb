require_relative "./register_set"

class Task
  attr_reader :pc

  def initialize(mars, address)
    @mars = mars
    @pc = address
  end

  def step
    registers = RegisterSet.new(@mars, @pc)
    @pc = registers.execute()
  end

  def to_s
    "PC:#{@pc}"
  end
end
