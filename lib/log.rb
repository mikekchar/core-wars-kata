require_relative "./event"

class Log
  def initialize(writer)
    @writer = writer
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
end
