class Event
  attr_reader :step_num

  # Note: Object must adhere to the interface:
  #   name: Name of the object
  #   id: ID of the object
  def initialize(step_num, object, message)
    @step_num = step_num
    @object = object
    @message = message
  end

  def to_s
    "[#{@step_num}] #{@object.name} #{@object.id} #{@message}"
  end
end
