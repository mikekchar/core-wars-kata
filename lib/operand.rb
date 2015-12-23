class Operand
  IMMEDIATE_RE = /#(\d+)/

  attr_reader :mode, :number

  def initialize(mode, number)
    @mode = mode
    @number = number
  end

  def ==(other)
    other.mode == @mode && other.number == @number
  end

  def to_s
    "#{@mode}#{@number}"
  end

  def self.build(string)
    matchdata = string.match(IMMEDIATE_RE)
    if matchdata
      address = matchdata[1].to_i(10)
      return Operand.new("#", address)
    else
      nil
    end
  end

end


