require_relative "./command"
require_relative "../instruction_parser"

class Step < Command
  STEP_RE = /^(-?[0-9]+)S$/

  def match(command)
    STEP_RE.match(command.upcase())
  end

  def execute
    return if @matchdata.nil?
    addr = @matchdata[1].to_i(10)
    @monitor.step(addr)
  end
end
