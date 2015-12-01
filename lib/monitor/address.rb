require_relative "./command"

class Address < Command
  ADDR_RE = /^-?[0-9a-fA-F]+$/

  def match(command)
    ADDR_RE.match(command)
  end

  def execute
    addr = @matchdata[0].to_i(16)
    output = @monitor.core.fetch(addr)
    if !output.nil?
      @monitor.writer.puts(output.to_s(16))
    else
      @monitor.writer.puts("Illegal address: #{command}")
    end
  end
end
