class Monitor
  ADDR_RE = /^d+$/

  def initialize(core, reader, writer)
    @prompt = "*" # Apple II Monitor prompt
    @core = core
    @reader = reader
    @writer = writer
    @finished = false
  end

  def read
    @reader.readline(@prompt, true)
  end

  def address?(command)
    return ADDR_RE.match(command)
  end

  # Shouldn't use reserved words...
  def exit_process
    @finished = true
  end

  def error(command)
    @writer.puts("Unknown command: #{command}")
  end

  def process
    while !@finished && command = read
      if command == "exit"
        exit_process()
      else
        error(command)
      end
    end
  end
end
