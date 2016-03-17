require_relative "./core"
require_relative "./warrior"
require_relative "./event"
require_relative "./log"

class Mars
  attr_reader :warriors, :log, :step_num, :core

  def initialize(core)
    @core = core
    @warriors = []
    @log = Log.new()
    @step_num = 0
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

  def addLog(object, message)
    @log.add(Event.new(@step_num, object, message))
  end

  def addWarrior(addr)
    warrior = Warrior.new(self, "#{@warriors.length}")
    addLog(warrior, "added")
    warrior.new_task(addr)
    @warriors << warrior
  end

  def removeDeadWarriors
    @warriors.each.with_index do |warrior, i|
      if warrior.killed?
        addLog(warrior, "killed")
        @warriors.delete_at(i)
      end
    end
  end

  def step(addr=nil)
    if !addr.nil?
      addWarrior(addr)
    end
    @warriors.each { |warrior| warrior.step() }
    removeDeadWarriors()
    @step_num += 1
  end

  def to_s
    @warriors.map { |warrior| warrior.to_s }.join("\n")
  end
end
