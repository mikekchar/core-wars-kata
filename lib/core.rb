require_relative "./dat"

class Core
  attr_reader :size

  def initialize(size)
    @size = size
    @impl = Array.new(size, Dat.build("#0, #0"))
  end

  def address(addr)
    addr % size
  end

  def store(addr, inst)
    return if inst.nil?
    @impl[address(addr)] = inst
  end
  
  def fetch(addr)
    @impl[address(addr)]
  end
end
