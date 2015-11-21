class Monitor
  ADDR_RE = /^\d+$/

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
    return !ADDR_RE.match(command).nil?
  end

  def inspect_address(command)
    addr = command.to_i
    output = @core.fetch(addr)
    if !output.nil?
      @writer.puts(output.to_s)
    else
      @writer.puts("Illegal address: #{addr}")
    end
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
      elsif address?(command)
        inspect_address(command)
      else
        error(command)
      end
    end
  end
end
