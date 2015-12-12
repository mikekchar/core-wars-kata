require_relative "./command"

class Address < Command
  ADDR_RE = /^-?[0-9a-fA-F]+$/

  def match(command)
    ADDR_RE.match(command)
  end

  def execute
    addr = @matchdata[0].to_i(16)
    output = @monitor.fetch(addr)
    if !output.nil?
      @monitor.puts(output.to_s())
    else
      @monitor.puts("Illegal address: #{command}")
    end
  end
end
