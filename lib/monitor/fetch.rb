require_relative "./command"

class Fetch < Command
  FETCH_RE = /^-?[0-9]+$/

  def match(command)
    FETCH_RE.match(command)
  end

  def execute
    addr = @monitor.address(@matchdata[0].to_i(10))
    output = @monitor.fetch(addr)
    if !output.nil?
      @monitor.puts("#{addr}:#{output.to_s()}")
    else
      @monitor.puts("Illegal address: #{command}")
    end
  end
end
