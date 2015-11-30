class Monitor
  attr_reader :core, :writer
  STORE_RE = /^(-?[0-9a-fA-F]+):([0-9a-fA-F]+)$/

  class Command
    def initialize(command, monitor)
      @matchdata = match(command)
      @monitor = monitor
    end

    def valid?
      !@matchdata.nil?
    end
  end

  class Address < Command
    ADDR_RE = /^-?[0-9a-fA-F]+$/

    def match(command)
      ADDR_RE.match(command)
    end

    def execute
      addr = @matchdata[0].to_i(16)
      output = @monitor.core.fetch(addr)
      if !output.nil?
        @monitor.writer.puts(output.to_s(16))
      else
        @monitor.writer.puts("Illegal address: #{command}")
      end
    end
  end

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

  def store?(command)
    return !STORE_RE.match(command).nil?
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
      address = Address.new(command, self)
      if command == "exit"
        exit_process()
      elsif address.valid?
        address.execute()
      elsif store?(command)
        store_value(command)
      else
        error(command)
      end
    end
  end
end
