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

  def error(errorText, command)
    @writer.puts("#{errorText}: #{command}")
  end

  def fetch(address)
    addr = @mars.address(address)
    output = @mars.fetch(addr)
    if !output.nil?
      @writer.puts("#{addr}:#{output.to_s()}")
    else
      error("Illegal address:", "#{command}")
    end
  end

  def store(address, instructionString)
    instruction = InstructionParser::parse(instructionString)
    if instruction.nil?
      error("Unknown instruction", instructionString)
    else
      @mars.store(address, instruction)
    end
  end

  def step(address)
    output = @mars.step(address)
    output.each { |line| @writer.puts(line) }
    examine()
  end

  def examine
    @writer.puts("Warriors")
    @writer.puts("--------")
    data = @mars.to_s()
    @writer.puts(data) if !data.empty?
  end

  def process
    while !@finished && input = read
      # FIXME: Find a more efficient way of doing this
      command = COMMANDS.map { |klass| klass.new(input, self) }
        .find { |cmd| cmd.valid? }
      if !command.nil?
        command.execute()
      else
        error("Unknown command", input)
      end
    end
  end
end
