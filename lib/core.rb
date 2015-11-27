class Core
  attr_reader :size

  def initialize(size)
    @size = size
    @impl = Array.new(size, 0)
  end

  def store(addr, value)
    @impl[addr % size] = value
  end
  
  def fetch(addr)
    @impl[addr % size]
  end
end
