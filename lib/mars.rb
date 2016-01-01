require_relative "./core"
require_relative "./warrior"

class Mars
  attr_reader :warriors

  def initialize(core)
    @core = core
    @warriors = []
  end

  def address(addr)
    @core.address(addr)
  end

  def store(addr, inst)
    @core.store(addr, inst)
  end

  def fetch(addr)
    @core.fetch(addr)
  end

  def step(addr)
    @warriors << Warrior.new(addr)
  end
end
