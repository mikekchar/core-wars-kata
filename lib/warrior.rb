class Warrior
  def initialize(mars, address)
    @mars = mars
    @address = address
    # The pc should really be on the task, but
    # we haven't got that far, so I'll put it here for now.
    @pc = address
  end

  def step
    # This shouldn't be here either.
    @pc = @mars.address(@pc + 1)
  end

  def to_s
    "PC:#{@pc}"
  end
end
