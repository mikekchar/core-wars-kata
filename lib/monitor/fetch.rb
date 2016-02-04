require_relative "./command"

class Fetch < Command
  FETCH_RE = /^-?[0-9]+$/

  def match(command)
    FETCH_RE.match(command)
  end

  def execute
    @monitor.fetch(@matchdata[0].to_i(10))
  end
end
