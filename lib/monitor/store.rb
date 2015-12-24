require_relative "./command"
require_relative "../dat"
require_relative "../operand"

class Store < Command
  STORE_RE = /^(-?[0-9]+):DAT\.F\s+#([0-9]+),\s+#([0-9]+)\s*$/

  def match(command)
    STORE_RE.match(command.upcase())
  end

  def execute
    return if @matchdata.nil?

    addr = @matchdata[1].to_i(10)
    a = "##{@matchdata[2]}"
    b = "##{@matchdata[3]}"
    @monitor.store(addr, Dat.build("#{a}, #{b}"))
  end
end
