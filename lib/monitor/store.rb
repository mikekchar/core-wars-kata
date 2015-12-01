require_relative "./command"

class Store < Command
  STORE_RE = /^(-?[0-9a-fA-F]+):([0-9a-fA-F]+)$/

  def match(command)
    STORE_RE.match(command)
  end

  def execute
    addr = @matchdata[1].to_i(16)
    value = @matchdata[2].to_i(16)
    # FIXME: better access for the core
    @monitor.core.store(addr, value)
  end
end
