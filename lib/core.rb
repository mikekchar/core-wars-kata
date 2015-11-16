class Core
  attr_reader :size

  def initialize(size)
    @size = size
    @impl = Array.new(size, 0)
  end

  def store(addr, value)
    # We are counting from zero ;-)
    return if addr >= size || addr < 0
    @impl[addr] = value
  end
  
  def fetch(addr)
    return nil if addr < 0
    @impl[addr]
  end
end
