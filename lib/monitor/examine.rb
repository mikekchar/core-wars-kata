require_relative "./command"

class Examine < Command
  EXAMINE_RE = /^E$/

  def match(command)
    EXAMINE_RE.match(command.upcase())
  end


  def execute
    return if @matchdata.nil?
    @monitor.examine()
  end
end
