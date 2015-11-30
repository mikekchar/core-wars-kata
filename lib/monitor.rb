class Monitor
  ADDR_RE = /^-?[0-9a-fA-F]+$/
  STORE_RE = /^(-?[0-9a-fA-F]+):([0-9a-fA-F]+)$/

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

  def store?(command)
    return !STORE_RE.match(command).nil?
  end

  def inspect_address(command)
    addr = command.to_i(16)
    output = @core.fetch(addr)
    if !output.nil?
      @writer.puts(output.to_s(16))
    else
      @writer.puts("Illegal address: #{command}")
    end
  end

  def store_value(command)
    if STORE_RE.match(command)
      addr = $1.to_i(16)
      value = $2.to_i(16)
      @core.store(addr, value)
    else
      @writer.puts("Illegal store command: #{command}")
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
      elsif store?(command)
        store_value(command)
      else
        error(command)
      end
    end
  end
end
