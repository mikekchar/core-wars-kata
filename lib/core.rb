require_relative "./dat"

class Core
  attr_reader :size

  def initialize(size)
    @size = size
    a = Operand.new("#", 0)
    b = Operand.new("#", 0)
    @impl = Array.new(size, Dat.new(a, b))
  end

  def store(addr, inst)
    @impl[addr % size] = inst
  end
  
  def fetch(addr)
    @impl[addr % size]
  end
end
