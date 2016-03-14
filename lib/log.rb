require_relative "./event"

class Log
  def initialize()
    @events = []
  end

  def reset
    @events = []
  end

  def add(event)
    @events << event
  end

  def to_strings
    @events.map do |event|
      event.to_s
    end
  end

  def at_step(step)
    @events.select { |event| event.step_num == step }.map do |event|
      event.to_s
    end
  end
end
