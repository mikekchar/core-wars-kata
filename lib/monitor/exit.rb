require_relative "./command"

class Exit < Command
  EXIT_RE = /^exit$/

  def match(command)
    EXIT_RE.match(command)
  end

  def execute
    @monitor.exit_process()
  end
end
