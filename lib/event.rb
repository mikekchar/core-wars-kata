class Event
  def initialize(object, num, message)
    @object = object
    @num = num
    @message = message
  end

  def to_s
    ">> #{@object} #{@num} #{@message}"
  end
end
