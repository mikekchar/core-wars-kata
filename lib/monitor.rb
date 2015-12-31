require_relative "./monitor/fetch"
require_relative "./monitor/exit"
require_relative "./monitor/store"
require_relative "./monitor/step"
require_relative "./monitor/examine"

class Monitor
  attr_reader :mars, :writer

  COMMANDS = [Exit, Fetch, Store, Step, Examine]

  def initialize(mars, reader, writer)
    @prompt = "*" # Apple II Monitor prompt
    @mars = mars
    @reader = reader
    @writer = writer
    @finished = false
  end

  def read
    @reader.readline(@prompt, true)
  end

  def exit_process
    @finished = true
  end

  def error(command)
    @writer.puts("Unknown command: #{command}")
  end

  def address(address)
    @mars.address(address)
  end

  def fetch(address)
    @mars.fetch(address)
  end

  def store(address, value)
    @mars.store(address, value)
  end

  def puts(value)
    @writer.puts(value)
  end

  def process
    while !@finished && input = read
      # FIXME: Find a more efficient way of doing this
      command = COMMANDS.map { |klass| klass.new(input, self) }
        .find { |cmd| cmd.valid? }
      if !command.nil?
        command.execute()
      else
        error(input)
      end
    end
  end
end
