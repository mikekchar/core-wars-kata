require_relative "./core"
require_relative "./warrior"
require_relative "./event"
require_relative "./log"

class Mars
  attr_reader :warriors, :log

  def initialize(core, logWriter)
    @core = core
    @warriors = []
    @log = Log.new(logWriter)
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

  def removeDeadWarriors
    @warriors.each.with_index do |warrior, i|
      if warrior.killed?
        @warriors.delete_at(i)
        @log.add(Event.new("Warrior", i, "killed"))
      end
    end
  end

  def step(addr)
    if !addr.nil?
      @log.add(Event.new("Warrior", @warriors.length, "added"))
      addWarrior(addr)
    end
    @warriors.each { |warrior| warrior.step() }
    removeDeadWarriors()
  end

  def to_s
    @warriors.map { |warrior| warrior.to_s }.join("\n")
  end
end
