class Event
  attr_reader :step_num

  def initialize(step_num, object, num, message)
    @step_num = step_num
    @object = object
    @num = num
    @message = message
  end

  def to_s
    "[#{@step_num}] #{@object} #{@num} #{@message}"
  end
end
