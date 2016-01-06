class Task
  attr_reader :pc

  def initialize(mars, address)
    @mars = mars
    @pc = address
  end

  def step
    @pc = @mars.address(@pc + 1)
  end

  def to_s
    "PC:#{@pc}"
  end
end
