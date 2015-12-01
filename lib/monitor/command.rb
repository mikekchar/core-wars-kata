class Command
  def initialize(command, monitor)
    @matchdata = match(command)
    @monitor = monitor
  end

  def valid?
    !@matchdata.nil?
  end
end
