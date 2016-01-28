class Cache
  def initialize(mars)
    @mars = mars
    @impl = {}
  end

  def fetch(address)
    @impl[@mars.address(address)] = @mars.fetch(address).clone()
  end

  def write
    @impl.each_pair do |address, instruction|
      @mars.store(address, instruction)
    end
  end

  def inspect(address)
    @impl[@mars.address(address)]
  end
end
