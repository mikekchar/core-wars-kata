class Monitor
  def initialize(reader, writer)
    @prompt = "> " # I can't remember what the Apple II monitor prompt was
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
      if command == "exit"
        exit_process()
      else
        error(command)
      end
    end
  end
end
