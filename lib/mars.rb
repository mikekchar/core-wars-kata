require_relative "./core"
require_relative "./warrior"

class Log
  def initialize(writer)
    @writer = writer
  end
end

class Mars
  attr_reader :warriors

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
    output = []
    @warriors.each.with_index do |warrior, i|
      if warrior.killed?
        @warriors.delete_at(i)
        output << ">> Warrior #{i} killed"
      end
    end
    output
  end

  def step(addr)
    output = []
    if !addr.nil?
      output << ">> Warrior #{@warriors.length} added"
      addWarrior(addr)
    end
    @warriors.each { |warrior| warrior.step() }
    output += removeDeadWarriors()
    output
  end

  def to_s
    output = @warriors.map { |warrior| warrior.to_s }
    output.join("\n")
  end
end
