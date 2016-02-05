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
    if !addr.nil?
      @warriors << Warrior.new(@core, addr)
    end
    @warriors.each { |warrior| warrior.step() }
    @warriors.delete_if { |warrior| warrior.killed? }
  end

  def to_s
    output = []
    @warriors.each_with_index do |warrior, i|
      output << "#{i} - #{warrior}"
    end
    output.join("\n")
  end
end
