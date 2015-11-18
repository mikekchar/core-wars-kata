class Monitor
  def initialize(prompt, reader)
    @prompt = prompt
    @reader = reader
  end

  def read
    @reader.readline(@prompt, true)
  end
end
