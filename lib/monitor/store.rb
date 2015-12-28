require_relative "./command"
require_relative "../dat"
require_relative "../operand"

class Store < Command
  STORE_RE = /^(-?[0-9]+):(.*)$/

  def match(command)
    # Not exactly the most efficient way to do this
    # i.e., if you build parsers this way, you are doing it wrong :-)
    # But... performance is not an issue at all for us and it's
    # a fun way to do it :-D
    matchdata = STORE_RE.match(command.upcase())
    instruction = matchdata[2]

  end

  def execute
    return if @matchdata.nil?

    addr = @matchdata[1].to_i(10)
    a = "##{@matchdata[2]}"
    b = "##{@matchdata[3]}"
    @monitor.store(addr, Dat.build("#{a}, #{b}"))
  end
end
