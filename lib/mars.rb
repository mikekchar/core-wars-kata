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
    @warriors << Warrior.new(self, addr)
    @warriors.each do |warrior| warrior.step() end
  end

  # TODO: make a Warriors class????
  # Also probably better to return the array...
  def warriors_to_s
    output = []
    @warriors.each_with_index do |warrior, i|
      output << "#{i} - #{warrior}"
    end
    output.join("\n")
  end
end
