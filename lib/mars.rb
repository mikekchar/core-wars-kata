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

  def addWarrior(addr)
    warrior = Warrior.new(@warriors.length, @core, addr)
    @warriors << warrior
  end

  def step(addr)
    output = []
    if !addr.nil?
      output << ">> Warrior #{@warriors.length} added"
      addWarrior(addr)
    end
    @warriors.each { |warrior| warrior.step() }
    @warriors.delete_if { |warrior| warrior.killed? }
    output
  end

  def to_s
    output = @warriors.map { |warrior| warrior.to_s }
    output.join("\n")
  end
end
