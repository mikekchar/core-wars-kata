require_relative "./command"
require_relative "../instruction_parser"

class Step < Command
  STEP_RE = /^(-?[0-9]+)S$/

  def match(command)
    # Not exactly the most efficient way to do this
    # i.e., if you build parsers this way, you are doing it wrong :-)
    # But... performance is not an issue at all for us and it's
    # a fun way to do it :-D
    STEP_RE.match(command.upcase())
  end

  def execute
    return if @matchdata.nil?
    addr = @matchdata[1].to_i(10)
    # Just for now
    @monitor.puts(addr.to_s)
  end
end
