require_relative "./command"
require_relative "../dat"
require_relative "../operand"

class Store < Command
  STORE_RE = /^(-?[0-9a-fA-F]+):DAT\.F #([0-9]+), #([0-9]+)$/

  def match(command)
    STORE_RE.match(command)
  end

  def execute
    return if @matchdata.nil?

    addr = @matchdata[1].to_i(16)
    a = Operand.new("#", @matchdata[2].to_i())
    b = Operand.new("#", @matchdata[3].to_i())
    @monitor.store(addr, Dat.new(a, b))
  end
end
