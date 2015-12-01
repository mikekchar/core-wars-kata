require_relative "./monitor/address"
require_relative "./monitor/exit"
require_relative "./monitor/store"

class Monitor
  attr_reader :core, :writer

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

  # Shouldn't use reserved words...
  def exit_process
    @finished = true
  end

  def error(command)
    @writer.puts("Unknown command: #{command}")
  end

  def process
    while !@finished && command = read
      exit_cmd = Exit.new(command, self)
      address = Address.new(command, self)
      store = Store.new(command, self)
      if exit_cmd.valid?
        exit_cmd.execute()
      elsif address.valid?
        address.execute()
      elsif store.valid?
        store.execute()
      else
        error(command)
      end
    end
  end
end
