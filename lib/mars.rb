require_relative "./core"
require_relative "./warrior"

class Event
  def initialize(object, num, message)
    @object = object
    @num = num
    @message = message
  end

  def to_s
    ">> #{@object} ##{@num} #{@messge}"
  end
end

class Log
  def initialize(writer)
    @writer = writer
    @events = []
  end

  def addEvent(event)
    @events << event
  end

  def to_s
    @events.each do |event|
      event.to_s
    end
  end
end

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
        @log.addEvent(Event.new("Warrior", i, "killed"))
      end
    end
  end

  def step(addr)
    if !addr.nil?
      @log.addEvent(Event.new("Warrior", @warriors.length, "added"))
      addWarrior(addr)
    end
    @warriors.each { |warrior| warrior.step() }
  end

  def to_s
    @warriors.map { |warrior| warrior.to_s }.join("\n")
  end
end
