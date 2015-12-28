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
    STORE_RE.match(command.upcase())
  end

  def build_instruction(instruction)
    Dat.construct(instruction)
  end

  def execute
    return if @matchdata.nil?
    instruction = build_instruction(@matchdata[2])

    addr = @matchdata[1].to_i(10)
    @monitor.store(addr, instruction)
  end
end
