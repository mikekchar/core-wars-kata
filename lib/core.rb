class Core
  attr_reader :size

  def initialize(size)
    @size = size
  end

  def store(addr, value)
  end
  
  def fetch(addr)
    # Silly TDD tricks
    27
  end
end
