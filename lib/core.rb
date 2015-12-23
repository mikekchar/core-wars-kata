require_relative "./dat"

class Core
  attr_reader :size

  def initialize(size)
    @size = size
    a = Operand.build("#0")
    b = Operand.build("#0")
    @impl = Array.new(size, Dat.new(a, b))
  end

  def address(addr)
    addr % size
  end

  def store(addr, inst)
    @impl[address(addr)] = inst
  end
  
  def fetch(addr)
    @impl[address(addr)]
  end
end
